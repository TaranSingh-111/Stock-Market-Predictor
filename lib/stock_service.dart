import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService{
  static const String _baseUrl = 'https://api.twelvedata.com';
  static const String _apiKey = 'e4418ed3031b40c395ffa9a98dea363e';

  Future<double?> getQuote(String symbol) async{
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
}

