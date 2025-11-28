import 'package:catalogo_exp_web/data/repositories/Grafico_repository.dart';
import 'package:catalogo_exp_web/models/Grafico_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'grafico_event.dart';
import 'grafico_state.dart';


class GraficoBloc extends Bloc<GraficoEvent, GraficoState> {
  final GraficoRepository repository;

  GraficoBloc(this.repository) : super(GraficoInitial()) {

    // EVENTO → carregar dados do Firebase
    on<CarregarGraficosRequested>((event, emit) async {
      emit(GraficoLoading());
      try {
        final dados = await repository.carregarEquipamentosPorCategoria();

        emit(GraficoLoaded(
          dados: dados,
          filtro: GraficoFiltro.grafico_pizza, // valor padrão
        ));
      } catch (e) {
        emit(GraficoError("Erro ao carregar gráfico: $e"));
      }
    });

    // EVENTO → mudar o tipo de gráfico (pizza/barras)
    on<MudarFiltroGrafico>((event, emit) {
      final estadoAtual = state;

      if (estadoAtual is GraficoLoaded) {
        emit(
          estadoAtual.copyWith(
            filtro: event.filtro,
          ),
        );
      }
    });
  }
}
