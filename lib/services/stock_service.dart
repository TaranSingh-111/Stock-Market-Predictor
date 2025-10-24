import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_market_predictor/stock_data.dart';

class StockService{
  static const String _baseUrl = 'https://api.twelvedata.com';
  final apiKeys = ['e4418ed3031b40c395ffa9a98dea363e', '68203d9da1414d2da68d87c2f9e87dea'];
  int currentKeyIndex = 0;


  String getNextApiKey() {
    String key = apiKeys[currentKeyIndex];
    currentKeyIndex = (currentKeyIndex + 1) % apiKeys.length; // cycles through 0–2
    return key;
  }

  Future<double?> getQuote(String symbol) async{
    final _apiKey = getNextApiKey();
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&apikey=$_apiKey');
    print(url);
    final res = await http.get(url);
    if(res.statusCode == 200){
      final data = jsonDecode(res.body);
      return double.tryParse(data['close'] ?? '');
    }
    else{
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getCandles(String symbol, String interval, int outputCount) async{
    final _apiKey = getNextApiKey();
    final url = Uri.parse('$_baseUrl/time_series?symbol=$symbol&interval=$interval&outputsize=$outputCount&apikey=$_apiKey');
    print(url);
    final res = await http.get(url);

    if(res.statusCode == 200){
      final data = jsonDecode(res.body);
      if(data['status'] == 'ok'){
        final List<Map<String, dynamic>> candles = [];
        for(var item in data['values']){
          candles.add({
            'time': DateTime.parse(item['datetime']).millisecondsSinceEpoch,
            'open': double.parse(item['open']),
            'high': double.parse(item['high']),
            'low' : double.parse(item['low']),
           'close': double.parse(item['close']),
          });
        }
        return candles.reversed.toList();
      }
    }
    return null;
  }

  Future<StockData?> getStockData(String symbol) async{
    try {
      final _apiKey = getNextApiKey();
      final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&apikey=$_apiKey');
      print(url);
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data != null) {
          return StockData(

            change: parseDouble(data['change']),
            pctChange: parseDouble(['percents_change']),

            exchange: data['exchange'] ?? '-',
            currency: data['currency'] ?? '-',
            open: parseDouble(data['open']),
            high: parseDouble(data['high']),
            low: parseDouble(data['low']),
            prevClose: parseDouble(data['previous_close']),
            high52: parseDouble(data['fifty_two_week']['high']),
            low52: parseDouble(data['fifty_two_week']['low']),
            dividend: parseDouble(data['dividend']),
            qtrDivAmt: parseDouble(data['qtrDivAmt']),

          );
        }
      }
      print("getStockData: API returned ${res.statusCode} or null data");
    }catch (e){
      print("getStockData error: $e");
    }

    return null;
  }

  double parseDouble(dynamic value){
    if(value == null)return 0.0;
    if(value is num) return value.toDouble();
    try{
      return double.parse(value.toString());
    }
    catch(e){
      return 0.0;
    }
  }
}

