import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:equatable/equatable.dart';

abstract class EquipamentoState extends Equatable {
  const EquipamentoState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial (antes de qualquer ação)
class EquipamentoInitial extends EquipamentoState {}

/// Estado de carregamento (quando está salvando ou buscando dados)
class EquipamentoLoading extends EquipamentoState {}

/// Estado quando a lista de equipamentos foi carregada com sucesso
class EquipamentoLoaded extends EquipamentoState {
  final List<Equipamento> equipamentos;
  final DateTime timestamp = DateTime.now();

  EquipamentoLoaded(this.equipamentos);

  @override
  List<Object?> get props => [equipamentos];
}

/// Estado de sucesso (ex: equipamento adicionado com êxito)
class EquipamentoSuccess extends EquipamentoState {}

/// Estado de erro (exibe mensagem na UI)
class EquipamentoError extends EquipamentoState {
  final String message;

  const EquipamentoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EquipamentoUpdated extends EquipamentoState {}

class EquipamentoAgrupado extends EquipamentoState {
  final Map<String, List<Equipamento>> grupos;

  const EquipamentoAgrupado(this.grupos);
}

class EquipamentoFavoritoState extends EquipamentoState {
  final List<Equipamento> favoritos;

  const EquipamentoFavoritoState({required this.favoritos});
}

