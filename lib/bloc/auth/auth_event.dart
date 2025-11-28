import 'package:equatable/equatable.dart';


class AuthEvent extends Equatable{
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent{
  final String nome;
  final String funcao;
  final String email;
  final String senha;

  const SignUpRequested({required this.nome, required this.email, required this.senha, required this.funcao});

  @override
  List<Object> get props => [email, senha];
}

class LogInRequested extends AuthEvent{
  final String email;
  final String senha;

  const LogInRequested({required this.email, required this.senha});

  @override
  List<Object> get props => [email, senha];
}

class LogOutRequested extends AuthEvent{  
  const LogOutRequested();

  @override
  List<Object> get props => [];
}

class DeleteAccountRequested extends AuthEvent {}

class AprovarUsuarioEvent extends AuthEvent {
  final String uid;
  const AprovarUsuarioEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class DesautorizarUsuarioEvent extends AuthEvent {
  final String uid;
  const DesautorizarUsuarioEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class CarregarUsuariosPendentesEvent extends AuthEvent {}

class MonitorAuthStateEvent extends AuthEvent {}


