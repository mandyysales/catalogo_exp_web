import 'package:catalogo_exp_web/models/Grafico.dart';
import 'package:catalogo_exp_web/models/Grafico_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget buildGraficoWidget(
  Map<String, int> dados,
  GraficoFiltro graficoTipo,
) {
  final List<GraficoItem> lista = converter(dados);

  final int total =
      lista.fold(0, (sum, item) => sum + item.quantidade);

  switch (graficoTipo) {
    case GraficoFiltro.grafico_pizza:
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCircularChart(
              title: ChartTitle(text: "Equipamentos por Categoria"),
              legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CircularSeries>[
                PieSeries<GraficoItem, String>(
                  dataSource: lista,
                  xValueMapper: (item, _) => item.categoria,
                  yValueMapper: (item, _) => item.quantidade,
                  dataLabelMapper: (item, _) {
                    final perc =
                        (item.quantidade / total * 100).toStringAsFixed(1);
                    return "${item.quantidade}\n($perc%)";
                  },
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  radius: "70%",
                ),
              ],
            ),
          ),
        ),
      );

    case GraficoFiltro.grafico_barras:
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCartesianChart(
              title: ChartTitle(text: "Equipamentos por Categoria"),
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<GraficoItem, String>(
                  dataSource: lista,
                  xValueMapper: (item, _) => item.categoria,
                  yValueMapper: (item, _) => item.quantidade,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
