import 'package:catalogo_exp_web/models/Grafico_enum.dart';
import 'package:equatable/equatable.dart';

abstract class GraficoState extends Equatable {
  const GraficoState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class GraficoInitial extends GraficoState {}

/// Loading enquanto busca dados
class GraficoLoading extends GraficoState {}

/// Sucesso — contém os dados já prontos
class GraficoLoaded extends GraficoState {
  final Map<String, int> dados;
  final GraficoFiltro filtro;

  const GraficoLoaded({
    required this.dados,
    required this.filtro,
  });

  @override
  List<Object?> get props => [dados, filtro];

  GraficoLoaded copyWith({
    Map<String, int>? dados,
    GraficoFiltro? filtro,
  }) {
    return GraficoLoaded(
      dados: dados ?? this.dados,
      filtro: filtro ?? this.filtro,
    );
  }
}

/// Erro
class GraficoError extends GraficoState {
  final String message;

  const GraficoError(this.message);

  @override
  List<Object?> get props => [message];
}
