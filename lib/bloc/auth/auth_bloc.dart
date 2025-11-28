
import 'package:catalogo_exp_web/bloc/auth/auth_event.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_state.dart';
import 'package:catalogo_exp_web/data/repositories/Auth_repository.dart';
import 'package:catalogo_exp_web/models/Administrador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) : _authRepository = authRepository, super(InitialState()){

    _authRepository.authStateChanges.listen((user) async {
      if (user == null) {
        emit(UnauthenticatedState());
        return;
      }

      final (isLogged, autorizado, role) = await _authRepository.getUserStatus();

      if (!autorizado) {
        emit(UnauthorizedState());
        return;
      }

      emit(AuthenticatedState(userid: user.uid, role: role));
    });


    on<SignUpRequested>((event, emit) async {
      emit(const LoadingState());
      try {
        final uid = await _authRepository.signup(
          nome: event.nome,
          email: event.email,
          senha: event.senha,
          funcao: event.funcao,
        );

        // Não autenticado! Apenas criado.
        emit(SignUpSuccessState(uid: uid));

      } on Exception catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogInRequested>((event, emit) async { //LogInRequested vem do auth_event 
      emit(const LoadingState()); //LoadingState vem do auth_state
      try{
        final (uid, role) = await _authRepository.login(email: event.email, senha: event.senha); //login vem do auth_repository
        emit(AuthenticatedState(userid: uid, role: role)); //AuthenticatedState vem do auth_state
      } on Exception catch(e){
        emit(AuthError(message: e.toString())); //AuthError vem do auth_state
      }   
      });



      on<LogOutRequested>((event, emit) async { //LogOutRequested vem do auth_event
        await _authRepository.signOut(); //signOut vem do auth_repository
        emit(const UnauthenticatedState()); //UnauthenticatedState vem do auth_state
      });

      on<DeleteAccountRequested>((event, emit) async {
      emit(const LoadingState());
      try {
        await _authRepository.deleteAccount();
        emit(const UnauthenticatedState());
      } on Exception catch (e) {
        emit(AuthError(message: "Erro ao excluir conta: $e"));
      } catch (e) {
        emit(AuthError(message: "Erro desconhecido: ${e.toString()}"));
      }
    });

    on<AprovarUsuarioEvent>((event, emit) async {
      emit(const LoadingState());
      try {
        await _authRepository.aprovarComoAuxiliar(event.uid);
        emit(const OperacaoSucessoState(mensagem: "Usuário autorizado como admin!"));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<DesautorizarUsuarioEvent>((event, emit) async {
      emit(const LoadingState());
      try {
        await _authRepository.desautorizarUsuario(event.uid);
        emit(const OperacaoSucessoState(mensagem: "Usuário removido com sucesso."));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    }); 

    on<CarregarUsuariosPendentesEvent>((event, emit) async {
      emit(UsuariosPendentesCarregandoState());

      try {
        await emit.forEach<List<Administrador>>(
          _authRepository.getUsuariosPendentes(),
          onData: (usuarios) => UsuariosPendentesCarregadosState(usuarios),
          onError: (_, error) =>
              UsuariosPendentesErroState(error.toString()),
        );
      } catch (e) {
        emit(UsuariosPendentesErroState(e.toString()));
      }
    });

  }
}




