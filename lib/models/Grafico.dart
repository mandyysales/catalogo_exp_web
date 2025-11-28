
class GraficoItem {
  final String categoria;
  final int quantidade;

  GraficoItem(this.categoria, this.quantidade);
}

List<GraficoItem> converter(Map<String, int> dados) {
  return dados.entries
      .map((e) => GraficoItem(e.key, e.value))
      .toList();
}

