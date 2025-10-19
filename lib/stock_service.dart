import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService{
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = 'd3q9979r01qgab53nuc0d3q9979r01qgab53nucg';

  static Future<Map<String, dynamic>?> getQuote(String symbol) async{
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey');
    final res = await http.get(url);
    if(res.statusCode == 200){
      return jsonDecode(res.body);
    }
    else{
      return null;
    }
  }

}

