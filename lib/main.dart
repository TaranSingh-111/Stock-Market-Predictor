import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'stock_chart_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Chart Getx',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const StockChartPage(symbol: 'AAPL', company: 'Apple Inc.'),
    );
  }
}