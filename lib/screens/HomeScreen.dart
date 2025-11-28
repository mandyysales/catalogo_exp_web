

import 'package:catalogo_exp_web/bloc/auth/auth_event.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_bloc.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_state.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/bloc/grafico/grafico_bloc.dart';
import 'package:catalogo_exp_web/bloc/grafico/grafico_event.dart';
import 'package:catalogo_exp_web/bloc/grafico/grafico_state.dart';
import 'package:catalogo_exp_web/data/repositories/Equipamento_repository.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/models/Grafico_enum.dart';

import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/ButtonPage.dart';
import 'package:catalogo_exp_web/widgets/Graficos_charts.dart';
import 'package:catalogo_exp_web/widgets/SingleButtonDialog.dart';
import 'package:catalogo_exp_web/widgets/TextFormIcon.dart';
import 'package:catalogo_exp_web/widgets/cards_equipamentos.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_medio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final buscar = TextEditingController();
  int _selectedIndex = 0;
  bool autorizado = false; 
  String role = 'normal';
  String filtroSelecionado = 'grafico_pizza';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Aqui você pode navegar entre telas:
    if (index == 1) context.push(AppRoutes.addFormsEquipamento);//Navigator.pushNamed(context, AppRoutes.addFormsEquipamento);
    if (index == 2)  context.go(AppRoutes.favoritos);//Navigator.pushNamed(context, AppRoutes.favoritos);
    if (index == 3)  _scaffoldKey.currentState?.openDrawer();
  }

  String _getTipoGrafico(GraficoFiltro filtro) {
    switch (filtro) {
      case GraficoFiltro.grafico_barras:
        return "Gráfico de Barras";
      case GraficoFiltro.grafico_pizza:
        return "Gráfico de Pizza";
    }
  }

  @override
  Widget build(BuildContext context){
    final state = context.watch<AuthBloc>().state;

    if (state is AuthenticatedState) {
      autorizado = state.autorizado;
      role = state.role;
    }
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: AppColors.orange),
                child: Text(
                  "Menu",
                  style: AppTextStyles.titleSmall(AppColors.black)
                ),
              ),
              if (role == 'admin')
                ListTile(
                  leading: Icon(Icons.person_search),
                  title: Text("Solicitações"),
                  onTap: () => context.go(AppRoutes.solicitacao) //Navigator.pushNamed(context, AppRoutes.solicitacao),
                ),
              if(autorizado)
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sair"),
                  onTap: () {
                    context.go(AppRoutes.login);
                    context.read<AuthBloc>().add(LogOutRequested());
                  },
                ),
              if(!autorizado)
                CustomButtonRetangularMedio(
                  text: "Entrar Como Administrador", 
                  onPressed: (){ context.go(AppRoutes.login);/*Navigator.pushNamed(context, "/login");*/}, 
                  backgroundColor: AppColors.blue
                ),

        ],
      ),
    ),   

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 400,
            collapsedHeight: 90,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.center,
                child: Text("Explora", style: AppTextStyles.titleLarge(AppColors.black)),
              ),
              background: Container(
                color: AppColors.orange,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text("O que você está procurando?", style:AppTextStyles.titleMedium(AppColors.orange),),
                  SizedBox(height: 30),
                  TextformIcon(
                    campo: "Pesquisar", 
                    controller: buscar,
                    icone: Icons.search, 
                    cor: AppColors.orange,
                    onPressed: () {
                      final query = buscar.text;
                      context.push(AppRoutes.resultadoPesquisa);

                      context.read<EquipamentoBloc>().add(
                        BuscarEquipamentoEvent(query: query),
                      );
                      /*Navigator.pushNamed(
                        context,
                        AppRoutes.resultadoPesquisa,
                      );*/
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      ButtonPage(nome: "Inicio", color: AppColors.orange, icon: Icons.home, onPressed: (){context.push(AppRoutes.home);/*Navigator.pushNamed(context, "/home");*/}),
                      SizedBox(width: 20),
                      ButtonPage(nome: "Equipamentos", color: AppColors.orange, icon: Icons.settings, onPressed: (){context.go(AppRoutes.equipamentos);/*Navigator.pushNamed(context, "/equipamentos")*/}),
                      SizedBox(width: 20),
                    ],
                  )
                ]
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Destaques: ",
                style: AppTextStyles.titleSmall(AppColors.orange)
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: StreamBuilder<List<Equipamento>>(
                stream: EquipamentoRepository().getTopVisualizados(limit: 3),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhum equipamento disponível"));
                  }

                  final topEquipamentos = snapshot.data!;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: topEquipamentos.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final equipamento = topEquipamentos[index];
                      return CustomCardEquipamentos(
                        equipamento: equipamento,
                        editar: autorizado, // aqui você verifica se o usuário está logado
                      );
                    },
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      Text(
                        "Dados do Sistema",
                        style: AppTextStyles.titleSmall(AppColors.orange),
                        ),
                      SizedBox(height: 10,),
                      Row(
                      children: [
                        Text("Tipo de Grafico:", style: AppTextStyles.bodyLight(AppColors.black),),
                        SizedBox(width: 12),

                        // 🌟 Dropdown controlado pelo GraficoBloc
                        BlocBuilder<GraficoBloc, GraficoState>(
                          builder: (context, state) {
                            if (state is GraficoLoaded) {
                              return DropdownButton<GraficoFiltro>(
                                value: state.filtro,
                                onChanged: (novo) {
                                  if (novo != null) {
                                    context
                                        .read<GraficoBloc>()
                                        .add(MudarFiltroGrafico(novo));
                                  }
                                },
                                items: GraficoFiltro.values.map((filtro) {
                                  return DropdownMenuItem(
                                    value: filtro,
                                    child: Text(_getTipoGrafico(filtro)),
                                  );
                                }).toList(),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ]
              )
            ),
          ),


          SliverToBoxAdapter(
            child: BlocBuilder<GraficoBloc, GraficoState>(
              builder: (context, state) {
                if (state is GraficoLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is GraficoLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: buildGraficoWidget(
                      state.dados,       // <- Mapa vindo do Firestore
                      state.filtro,      // <- Tipo de gráfico selecionado
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botão 1 - Adicionar experimento
              if (autorizado)
                FloatingActionButton.small(
                  heroTag: "add",
                  backgroundColor: _selectedIndex == 1 ? Colors.orange : Colors.grey[300],
                  onPressed: () => _onItemTapped(1),
                  child: const Icon(Icons.add, color: Colors.white),
                ),

              // Botão 2 - Favoritos
              FloatingActionButton.small(
                heroTag: "fav",
                backgroundColor: _selectedIndex == 2 ? Colors.orange : Colors.grey[300],
                onPressed: () => _onItemTapped(2),
                child: const Icon(Icons.favorite, color: Colors.white),
              ),

              // Botão 3 - Configurações
              FloatingActionButton.small(
                heroTag: "menu",
                backgroundColor: _selectedIndex == 3 ? Colors.orange : Colors.grey[300],
                onPressed: () => _onItemTapped(3),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}