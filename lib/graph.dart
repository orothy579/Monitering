import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  int extractNumber(String str) {
    final RegExp regExp = RegExp(r'\d+');
    final Iterable<Match> matches = regExp.allMatches(str);
    if (matches.isNotEmpty) {
      return int.parse(matches.first.group(0) ?? '0');
    }
    return 0;
  }

  DateTime parseCustomDateTime(String dateTimeStr) {
    final year = int.parse(dateTimeStr.substring(0, 4));
    final month = int.parse(dateTimeStr.substring(4, 6));
    final day = int.parse(dateTimeStr.substring(6, 8));
    final hour = int.parse(dateTimeStr.substring(8, 10));
    final minute = int.parse(dateTimeStr.substring(10, 12));
    final second = int.parse(dateTimeStr.substring(12, 14));

    return DateTime(year, month, day, hour, minute, second);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('my_collection').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                var chartData = snapshot.data!.docs.map((doc) => SalesData(
                  doc.id,
                  extractNumber(doc['xbee_data'].toString()).toDouble(),
                )).toList();
                 return SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.seconds, // Update interval type to seconds
                    dateFormat: DateFormat('hh:mm:ss'), // Update date format to show hours, minutes, and seconds
                    majorGridLines: MajorGridLines(width: 0),
                  ),
                  series: <ChartSeries>[
                    LineSeries<SalesData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (SalesData sales, _) => parseCustomDateTime(sales.year),
                      yValueMapper: (SalesData sales, _) => sales.sales,
                    )
                  ],
                );

              }
            },
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
