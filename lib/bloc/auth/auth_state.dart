
import 'package:catalogo_exp_web/models/Administrador.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

}

class InitialState extends AuthState{
  const InitialState(); //Essse é o estado qnd o usuario ainda não foi autenticado;

  @override
  List<Object> get props => [];
}

class  LoadingState extends AuthState{
  const LoadingState();
}

class SignUpSuccessState extends AuthState {
  final String uid;
  const SignUpSuccessState({required this.uid});
}

class AuthenticatedState extends AuthState {
  final String userid;
  final String role;            // admin | auxiliar | comum
  final bool autorizado;        // true ou false

  const AuthenticatedState({
    required this.userid,
    required this.role,
  }) : autorizado = (role == 'admin' || role == 'auxiliar');

  @override
  List<Object> get props => [userid, role, autorizado];
}

class  UnauthenticatedState extends AuthState{
  const UnauthenticatedState();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OperacaoSucessoState extends AuthState {
  final String mensagem;

  const OperacaoSucessoState({required this.mensagem});

  @override
  List<Object?> get props => [mensagem];
}

class UsuariosPendentesCarregandoState extends AuthState {}

/// Lista carregada
class UsuariosPendentesCarregadosState extends AuthState {
  final List<Administrador> usuarios;
  UsuariosPendentesCarregadosState(this.usuarios);
}

/// Erro
class UsuariosPendentesErroState extends AuthState {
  final String message;
  UsuariosPendentesErroState(this.message);
}

class UsuarioAprovadoState extends AuthState {}

/// Após recusar
class UsuarioDesautorizadoState extends AuthState {}

class UnauthorizedState extends AuthState {}
