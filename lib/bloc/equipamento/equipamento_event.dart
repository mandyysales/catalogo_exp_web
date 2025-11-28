
import 'dart:typed_data';

import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class EquipamentoEvent extends Equatable {
  const EquipamentoEvent();

  @override
  List<Object?> get props => [];
}

/// Quando o usuário adiciona um novo equipamento
class AddEquipamentoEvent extends EquipamentoEvent {
  final Equipamento equipamento;
  final File? imagem; // opcional, caso o usuário envie uma imagem
  final Uint8List? imagemWb;


  const AddEquipamentoEvent({
    required this.equipamento,
    this.imagem,
    this.imagemWb,
  });

  @override
  List<Object?> get props => [equipamento, imagem];
}

/// Quando a lista de equipamentos deve ser carregada
class LoadEquipamentosEvent extends EquipamentoEvent {}

/// Quando há necessidade de atualizar um equipamento existente
class UpdateEquipamentoEvent extends EquipamentoEvent {
  final Equipamento equipamento;
  final Uint8List? imagemWb;

  const UpdateEquipamentoEvent({
    required this.equipamento,
    this.imagemWb,
  });

  @override
  List<Object?> get props => [ equipamento, imagemWb];
}

/// Quando um equipamento é removido
class DeleteEquipamentoEvent extends EquipamentoEvent {
  final String id;

  const DeleteEquipamentoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AgruparPorCategoriaEvent extends EquipamentoEvent {}

class BuscarEquipamentoEvent extends EquipamentoEvent{
  final String query;
  const BuscarEquipamentoEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class AdicionarEquipamentoFavoritoEvent extends EquipamentoEvent{
  final Equipamento equipamento;
  AdicionarEquipamentoFavoritoEvent({required this.equipamento});

  @override
  List<Object?> get props => [equipamento];
}

class RemoverEquipamentoFavoritoEvent extends EquipamentoEvent {
  final Equipamento equipamento;

  RemoverEquipamentoFavoritoEvent({required this.equipamento});

  @override
  List<Object?> get props => [equipamento];
}

class FetchFavoritosEvent extends EquipamentoEvent {} 
