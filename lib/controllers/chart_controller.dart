import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_predictor/services/stock_service.dart';
import 'package:stock_market_predictor/stock_data.dart';

enum RangeOption { threeHours, oneDay, oneWeek, oneMonth, threeMonths, oneYear}

class ChartController extends GetxController{
  final String symbol;
  final _service = StockService();

  var candles = <Map<String, dynamic>>[].obs;
  var currentPrice =0.0.obs;
  var stockData = Rx<StockData?>(null);
  var isLoading = false.obs;
  var selectedRange = RangeOption.oneMonth.obs;

  Timer? _timer;

  final Map<RangeOption, List<Map<String, dynamic>>> _cache = {};

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
    final range = selectedRange.value;

    if (_cache.containsKey(range)) {
      candles.assignAll(_cache[range]!);
      await fetchLiveQuote(); // still update live price
      isLoading.value = false;
      return;
    }

    String interval;
    int outputCount;

    switch(selectedRange.value){
      case RangeOption.threeHours:
        interval = '1min';
        outputCount = 180;
        break;
      case RangeOption.oneDay:
        interval = '5min';
        outputCount = 78;
        break;
      case RangeOption.oneWeek:
        interval = '1h';
        outputCount = 7;
        break;
      case RangeOption.oneMonth:
        interval = '1h';
        outputCount = 500;
        break;
      case RangeOption.threeMonths:
        interval = "4h";
        outputCount = 800;
      case RangeOption.oneYear:
        interval = '1day';
        outputCount = 365;
        break;
    }

    final data = await _service.getCandles(symbol, interval, outputCount);
    if(data != null){
      _cache[range] = data;
      candles.assignAll(data);
    }
    await fetchLiveQuote();
    isLoading.value = false;

    await fetchStockDetails();
  }

  Future<void> fetchLiveQuote() async{
    final price = await _service.getQuote(symbol);
    if(price != null)
      currentPrice.value = price;
  }

  Future<void> fetchStockDetails() async{
    final details = await _service.getStockData(symbol);
    if(details != null)
      stockData.value = details;
  }

  void changeRange(RangeOption range){
    if(selectedRange.value != range){
      selectedRange.value = range;
      fetchData();
    }
  }
}