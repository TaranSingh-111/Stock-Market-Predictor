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

  final Map<RangeOption, List<Map<String, dynamic>>> _cache = {};

  ChartController(this.symbol);

  @override
  void onInit(){
    super.onInit();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 200), (_) => fetchLiveQuote());
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
      case RangeOption.oneDay:
        interval = '15min';
        outputCount = 96;
        break;
      case RangeOption.oneWeek:
        interval = '1h';
        outputCount = 168;
        break;
      case RangeOption.oneMonth:
        interval = '1day';
        outputCount = 30;
        break;
      case RangeOption.oneYear:
        interval = '1month';
        outputCount = 12;
        break;
    }

    final data = await _service.getCandles(symbol, interval, outputCount);
    if(data != null){
      _cache[range] = data;
      candles.assignAll(data);
    }
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
}