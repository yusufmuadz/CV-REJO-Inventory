import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeChartWidget extends StatelessWidget {
  const HomeChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.35,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          SplineAreaSeries<SalesData, String>(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.white],
            ),
            borderColor: Colors.blueAccent, // Warna border biru tua
            borderWidth: 2, // Lebar border
            opacity: 0.5,
            dataSource: <SalesData>[
              SalesData('Senin', 40),
              SalesData('Selasa', 50),
              SalesData('Rabu', 35),
              SalesData('Kamis', 60),
              SalesData('Jumat', 40),
              SalesData('Sabtu', 40),
            ],
            xValueMapper: (SalesData sales, _) => sales.day,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }
}

class SalesData {
  final String day;
  final double sales;

  SalesData(this.day, this.sales);
}
