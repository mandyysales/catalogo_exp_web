import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/core/auth/auth_helpers.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/screens/Result_Pesquisa_Screen.dart';
import 'package:catalogo_exp_web/screens/authentication/inicio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../screens/HomeScreen.dart';
import '../screens/EquipamScreen.dart';
import '../screens/authentication/login.dart';
import '../screens/authentication/cadastro.dart';
import '../screens/DetalhesEquipamento_screen.dart';
import '../screens/Adicionar_Equip_Screen.dart';
import '../screens/Lista_Favoritos_Screen.dart';
import '../screens/Lista_Solicitacoes_Screen.dart';
import '../router/Rotas.dart';
import 'go_router_refresh_stream.dart';


class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;
  late final GoRouterRefreshStream _refreshStream;

  AppRouter({required this.authBloc}) {
    // transforma a stream do bloc em refreshListenable
    _refreshStream = GoRouterRefreshStream(authBloc.stream);

    router = GoRouter(
      initialLocation: AppRoutes.root,
      refreshListenable: _refreshStream,
      debugLogDiagnostics: false,
      // redirect global: trata acesso a rotas protegidas
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        
        final loggedIn = isLoggedIn(authState);
        final role = getRole(authState);

        final loc = state.subloc;

        // rotas que exigem admin/auxiliar:
        if (loc == AppRoutes.addFormsEquipamento) {


          if (!loggedIn) return AppRoutes.login;
          if (!(role == 'admin' || role == 'auxiliar')) return AppRoutes.home;
        }

        // rota que exige admin:
        if (loc == AppRoutes.solicitacao) {
          print("Tentativa de acesso a Solicitacao. Estado atual: $authState");
          final loggedIn = isLoggedIn(authState); // Isso deve ser TRUE
          final role = getRole(authState);       // Isso deve ser 'admin'

          if (!loggedIn) { 
            print("Redirecionando para login (não logado)");
            return AppRoutes.login;

          }
          if (role != 'admin') return AppRoutes.home;
        }

        // se está tentando acessar login/cadastro quando já está logado:
        if ((loc == AppRoutes.login || loc == AppRoutes.cadastro) && loggedIn) {
          return AppRoutes.home;
        }

        // sem redirecionamento
        return null;
      },

      routes: <GoRoute>[
        GoRoute(
          path: AppRoutes.root,
          name: 'entrada',
          builder: (context, state) => const TelaInicial(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.cadastro,
          name: 'cadastro',
          builder: (context, state) => const CadastroScreen(),
        ),
        GoRoute(
          path: AppRoutes.equipamentos,
          name: 'equipamentos',
          builder: (context, state) => const Equipamscreen(),
        ),
        GoRoute(
          path: AppRoutes.resultadoPesquisa,
          name: 'resultadoPesquisa',
          builder: (context, state) => const ResultPesquisaScreen(),
        ),

        // rota com argumento (equipamento) -> usamos `state.extra`
        /*GoRoute(
          path: AppRoutes.addFormsEquipamento,
          name: 'addEquip',
          builder: (context, state) {
            final equipamento = state.extra as Equipamento?;
            return FormAddEquipamento(equipamento: equipamento);
          },
        ),*/

        GoRoute(
          path: AppRoutes.addFormsEquipamento,
          name: 'addEquip',
          builder: (context, state) {
          final equipamento = state.extra is Equipamento ? state.extra as Equipamento : null;           
           return FormAddEquipamento(equipamento: equipamento);
          },
        ),

        GoRoute(
          path: AppRoutes.detalhesEquipamento,
          name: 'detalhes',
          builder: (context, state) {
            // extra SEMPRE será Equipamento
            final equipamento = state.extra as Equipamento?;

            if (equipamento == null) {
              return const Center(child: Text('Equipamento não encontrado'));
            }

            return BlocProvider.value(
              value: context.read<EquipamentoBloc>(),
              child: DetalhesEquipamentoScreen(equipamento: equipamento),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.favoritos,
          name: 'favoritos',
          builder: (context, state) {
            return BlocProvider.value(
              value: context.read<EquipamentoBloc>(),
              child: const FavoritosScreen(),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.solicitacao,
          name: 'solicitacao',
          builder: (context, state) {
            return BlocProvider.value(
              value: context.read<AuthBloc>(),
              child: const ListaSolicitacoesScreen(),
            );
          },
        ),
      ],
    );
  }

  // fechar a subscription quando destruir o router
  void dispose() {
    _refreshStream.dispose();
  }
}
