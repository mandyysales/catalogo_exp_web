import 'package:catalogo_exp_web/models/Grafico_enum.dart';
import 'package:equatable/equatable.dart';

abstract class GraficoEvent extends Equatable {
  const GraficoEvent();

  @override
  List<Object?> get props => [];
}

/// Carrega os dados do Firebase
class CarregarGraficosRequested extends GraficoEvent {}

/// Troca o tipo de gráfico (pizza ↔ barras)
class MudarFiltroGrafico extends GraficoEvent {
  final GraficoFiltro filtro;

  const MudarFiltroGrafico(this.filtro);

  @override
  List<Object?> get props => [filtro];
}
