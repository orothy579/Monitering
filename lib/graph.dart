import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData(DateTime(2010), 35.0),
      SalesData(DateTime(2011), 28.0),
      SalesData(DateTime(2012), 11.0),
      SalesData(DateTime(2013), 22.0),
      SalesData(DateTime(2014), 30.0)
    ];


    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                      // Renders line chart
                      LineSeries<SalesData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales)
                    ]))));
  }



}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
