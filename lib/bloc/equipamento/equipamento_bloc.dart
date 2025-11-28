import 'package:catalogo_exp_web/bloc/auth/auth_state.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'equipamento_event.dart';
import 'equipamento_state.dart';
import '../../data/repositories/equipamento_repository.dart';

class EquipamentoBloc extends Bloc<EquipamentoEvent, EquipamentoState> {
  final EquipamentoRepository repository;
  List<Equipamento> _listaCompleta = [];
  List<Equipamento> _favoritos = [];


  EquipamentoBloc(this.repository) : super(EquipamentoInitial()) {
    on<LoadEquipamentosEvent>(_onLoadEquipamentos);
    on<AddEquipamentoEvent>(_onAddEquipamento);
    on<DeleteEquipamentoEvent>(_onDeleteEquipamento);
    on<UpdateEquipamentoEvent>(_onUpdateEquipamento);
    on<AgruparPorCategoriaEvent>(_onAgruparPorCategoriaEvent);
    on<BuscarEquipamentoEvent>(_onBuscarEquipamentos);
    on<AdicionarEquipamentoFavoritoEvent>(_onAdicionarEquipamentoFavorito);
    on<RemoverEquipamentoFavoritoEvent>(_onRemoverEquipamentoFavorito);
    on<FetchFavoritosEvent>(_onFetchFavoritos);

  }

  // -------------------------------------------------------
  //  1) STREAM - carrega em tempo real
  // -------------------------------------------------------
  /*Future<void> _onLoadEquipamentos(
      LoadEquipamentosEvent event, Emitter<EquipamentoState> emit) async {
    emit(EquipamentoLoading());
    try {
      final stream = repository.getEquipamentos();

      await emit.forEach<List<Equipamento>>(
        stream,
        onData: (equipamentos) { 
          _listaCompleta = equipamentos;
          return EquipamentoLoaded(equipamentos);
        },
      );
    } catch (e) {
      emit(EquipamentoError(message: 'Erro ao carregar equipamentos: $e'));
    }
  }*/


  Future<void> _onLoadEquipamentos(
      LoadEquipamentosEvent event, Emitter<EquipamentoState> emit) async {
    emit(EquipamentoLoading());
    try {
      final stream = repository.getEquipamentos();

      await emit.forEach<List<Equipamento>>(
        stream,
        onData: (equipamentos) {
          _listaCompleta = equipamentos;

          if (state is EquipamentoFavoritoState) {
            final favoritosAntigos = (state as EquipamentoFavoritoState).favoritos;

            final idsAntigos = favoritosAntigos.map((e) => e.id).toSet();

            final favoritosAtualizados = equipamentos
                .where((e) => idsAntigos.contains(e.id))
                .toList();

            return EquipamentoFavoritoState(favoritos: favoritosAtualizados);
          }

          return EquipamentoLoaded(equipamentos);
        },
      );
    } catch (e) {
      emit(EquipamentoError(message: 'Erro ao carregar equipamentos: $e'));
    }
  }

  // -------------------------------------------------------
  //  2) ADICIONAR
  // -------------------------------------------------------
Future<void> _onAddEquipamento(
    AddEquipamentoEvent event, 
    Emitter<EquipamentoState> emit
) async {

  emit(EquipamentoLoading());

  try {
    // Primeiro salva sem imagem (temporário)
    var equipamento = event.equipamento;
    print('Tentando salvar');
    // Agora manda para o repository, que trata a imagem corretamente
    final equipamentoSalvo = await repository.addEquipamento(
      equipamento,
      event.imagemWb,   // <-- passa a imagem aqui
    );

    emit(EquipamentoSuccess());

    // recarrega lista automaticamente
    add(LoadEquipamentosEvent());

  } catch (e) {
    print('ERRO NO BLOC: $e');
    emit(EquipamentoError(message:'Erro ao adicionar equipamento: $e'));
  }
}


  // -------------------------------------------------------
  //  3) DELETAR
  // -------------------------------------------------------
  Future<void> _onDeleteEquipamento(
      DeleteEquipamentoEvent event, Emitter<EquipamentoState> emit) async {
    try {
      await repository.deletarEquipamento(event.id);
      add(LoadEquipamentosEvent());
    } catch (e) {
      emit(EquipamentoError(message: 'Erro ao deletar equipamento: $e'));
    }
  }

  // -------------------------------------------------------
  //  4) ATUALIZAR
  // -------------------------------------------------------
  Future<void> _onUpdateEquipamento(
    UpdateEquipamentoEvent event,
    Emitter<EquipamentoState> emit,
  ) async {
    emit(EquipamentoLoading());

    try {
      await repository.updateEquipamento(
        event.equipamento,
        event.imagemWb,
      );

      emit(EquipamentoUpdated());
      add(LoadEquipamentosEvent());
    } catch (e) {
      emit(EquipamentoError(message: 'Erro ao atualizar equipamento: $e'));
    }
  }

  // -------------------------------------------------------
  //  5) AGRUPAR POR CATEGORIA (corrigido)
  // -------------------------------------------------------
  void _onAgruparPorCategoriaEvent(
    AgruparPorCategoriaEvent event,
    Emitter<EquipamentoState> emit,
  ) {
    if (state is! EquipamentoLoaded) {
      emit(EquipamentoAgrupado({}));
      return;
    }

    final equipamentos = (state as EquipamentoLoaded).equipamentos;
    final Map<String, List<Equipamento>> grupos = {};

    for (var eq in equipamentos) {
      // pega a primeira categoria OU "Sem categoria"
      final categoria = (eq.categorias.isNotEmpty)
          ? eq.categorias.first
          : "Sem categoria";

      grupos.putIfAbsent(categoria, () => []);
      grupos[categoria]!.add(eq);
    }

    emit(EquipamentoAgrupado(grupos));
  }

  // -------------------------------------------------------
  //  6) Pesquisar por Equipameto (corrigido)
  // -------------------------------------------------------

    void _onBuscarEquipamentos(
      BuscarEquipamentoEvent event,
      Emitter<EquipamentoState> emit,
    ) {
      try {
        emit(EquipamentoLoading());
        final query = event.query.toLowerCase().trim();

        if (query.isEmpty) {
          emit(EquipamentoError(message: "Nada inserido no campo de busca..."));
          return;
        }

        if(_listaCompleta.isEmpty){
          add(LoadEquipamentosEvent());
          emit(EquipamentoError(message: "Nenhum Equipamento Cadastrado"));
          return;
        }


        final palavras = query.split(" ");

        final filtrados = _listaCompleta.where((equip) {
          final texto = "${equip.nome} ${equip.marca} ${equip.code} ${equip.categorias.join(" ")}"
              .toLowerCase();

          return palavras.every((p) => texto.contains(p)); //pode usar any ou every 
        }).toList();
        if(filtrados.isEmpty){
          return emit(EquipamentoError(message: "Nenhum Equipamento encontrado, tente usar palavras chaves na busca"));
        }
        emit(EquipamentoLoaded(filtrados));
      } catch (e) {
        emit(EquipamentoError(message: "Erro na busca: $e"));
      }
    }


  // -------------------------------------------------------
  //  5) Favoritos Adiconar e Remover (corrigido)
  // -------------------------------------------------------
 void _onAdicionarEquipamentoFavorito(
  AdicionarEquipamentoFavoritoEvent event,
  Emitter<EquipamentoState> emit,
) {
  print('BLOC: recebeu AdicionarFavorito id=${event.equipamento.id}');
  final novaLista = List<Equipamento>.from(_favoritos);
   print('BLOC: favoritos antes=${_favoritos.map((e)=>e.id).toList()}');
  // Evitar duplicados
  if (!novaLista.any((e) => e.id == event.equipamento.id)) {
    novaLista.add(event.equipamento);
  }

  _favoritos = novaLista;

  
  print('BLOC: favoritos depois=${_favoritos.map((e)=>e.id).toList()}');
  // ESTE É O ESTADO QUE SUA TELA DE FAVORITOS ESPERA
  emit(EquipamentoFavoritoState(favoritos: List.from(_favoritos)));
  print('BLOC: emitiu EquipamentoFavoritoState');
}

  bool isFavorito(Equipamento equipamento) {
    return _favoritos.any((e) => e.id == equipamento.id);
  }

void _onRemoverEquipamentoFavorito(
  RemoverEquipamentoFavoritoEvent event,
  Emitter<EquipamentoState> emit,
) {
  final novaLista = List<Equipamento>.from(_favoritos);

  // Remove pelo ID
  novaLista.removeWhere((eq) => eq.id == event.equipamento.id);

  _favoritos = novaLista;

  emit(EquipamentoFavoritoState(favoritos: List.from(_favoritos)));
}


  void _onFetchFavoritos(
    FetchFavoritosEvent event,
    Emitter<EquipamentoState> emit,
  ) {
    // Simplesmente re-emite o estado atual dos favoritos que já estão na memória (_favoritos)
    emit(EquipamentoFavoritoState(favoritos: List.from(_favoritos)));
  }

  

}
