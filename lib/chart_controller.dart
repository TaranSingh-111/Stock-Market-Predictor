import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_predictor/stock_service.dart';

enum RangeOption { oneDay, oneWeek, oneMonth, oneYear}

class ChartController extends GetxController{
  final String symbol;
  final _service = StockService();

  var candles = <Map<String, dynamic>>[].obs;
  var currentPrice =0.0.obs;
  var isLoading = false.obs;
  var selectedRange = RangeOption.oneMonth.obs;

  Timer? _timer;

  ChartController(this.symbol);

  @override
  void onInit(){
    super.onInit();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 1000), (_) => fetchLiveQuote());
  }

  @override
  void onClose(){
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchData() async{
    isLoading.value = true;

    String interval;
    int outputCount;

    switch(selectedRange.value){
      case RangeOption.oneDay:
        interval = '5min';
        outputCount = 78;
        break;
      case RangeOption.oneWeek:
        interval = '30min';
        outputCount = 78 * 5;
        break;
      case RangeOption.oneMonth:
        interval = '1day';
        outputCount = 30;
        break;
      case RangeOption.oneYear:
        interval = '1week';
        outputCount = 52;
        break;
    }

    final data = await _service.getCandles(symbol, interval, outputCount);
    if(data != null)
      candles.assignAll(data);
    await fetchLiveQuote();
    isLoading.value = false;
  }

  Future<void> fetchLiveQuote() async{
    final price = await _service.getQuote(symbol);
    if(price != null)
      currentPrice.value = price;
  }

  void changeRange(RangeOption range){
    if(selectedRange.value != range){
      selectedRange.value = range;
      fetchData();
    }
  }

  // @override
  // void onReady(){
  //   super.onReady();
  //   fetchLiveQuote('AAPL');
  //   ever(selectedRange, (_) => fetchLiveQuote('AAPL'));
  //   _startAutoRefresh();
  // }
  // void _startAutoRefresh(){
  //   Future.doWhile(() async{
  //     await Future.delayed(const Duration(seconds: 15));
  //     await fetchLiveQuote('AAPL');
  //     return true;
  //   });
  // }
  //
  // late Map<RangeOption, List<Map<String, double>>> _mockData;
  // List<Map<String, double>> get currentData => _mockData[selectedRange.value]!;
  // @override
  // void onInit(){
  //   super.onInit();
  //   _mockData ={
  //     RangeOption.oneDay : _generateMockSeries(points: 78, volatility: 0.7, startPrice: 176.0),
  //     RangeOption.oneWeek: _generateMockSeries(points: 28, volatility: 1.2, startPrice: 170.0),
  //     RangeOption.oneMonth: _generateMockSeries(points: 30, volatility: 1.8, startPrice: 160.0),
  //     RangeOption.oneYear: _generateMockSeries(points: 52, volatility: 3.5, startPrice: 120.0),
  //     RangeOption.all: _generateMockSeries(points: 120, volatility: 4.0, startPrice: 40.0),
  //   };
  //   prepareChart();
  // }
  //
  // List<Map<String, double>> _generateMockSeries({required int points, required double volatility, required double startPrice}){
  //
  //   final rnd = Random(42);
  //   double price = startPrice;
  //   final now = DateTime.now().toUtc();
  //   final List<Map<String, double>> series = [];
  //   for(int i =0; i < points; i++){
  //     final timeStamp = now.subtract(Duration(minutes: (points-1)*15)).millisecondsSinceEpoch.toDouble();
  //     final change = (rnd.nextDouble() -0.5) * volatility;
  //     price =(price + change).clamp(1.0, 100000.0);
  //     series.add({'t': timeStamp, 'p':double.parse(price.toStringAsFixed(2))});
  //   }
  //   return series;
  // }
  //
  // void prepareChart(){
  //
  //   final data = currentData;
  //   spots.value = List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]['p']!));
  //   minY.value = spots.map((s) => s.y).reduce(min) * .995;
  //   maxY.value = spots.map((s) => s.y).reduce(max) * 1.005;
  //   lastUpdated.value = DateTime.fromMillisecondsSinceEpoch((data.last['t']! * 1000).toInt()).toLocal().toString();
  // }


}