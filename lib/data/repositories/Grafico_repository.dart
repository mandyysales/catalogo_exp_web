
import 'package:cloud_firestore/cloud_firestore.dart';

class GraficoRepository {
  final FirebaseFirestore firestore;

  GraficoRepository({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, int>> carregarEquipamentosPorCategoria() async {
    final query = await firestore.collection('equipamentos').get();

    Map<String, int> porCategoria = {};

    for (var doc in query.docs) {
      final data = doc.data();

      // lista de categorias (ex: ['Química', 'Vidrarias'])
      final List categorias = data['categorias'] ?? [];

      // quantidade do equipamento
      final int quantidade = data['quantidade'] ?? 1;

      // somar quantidade para cada categoria
      for (var cat in categorias) {
        porCategoria[cat] = (porCategoria[cat] ?? 0) + quantidade;
      }
    }

    return porCategoria;
  }
}
