import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Stock{
  final String name;
  final String symbol;
  Stock({required this.name, required this.symbol});
}

class SearchController extends GetxController{
  final stocks = <Stock>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  final String apiKey = '0c6b6b5fc1b64732b232245a52a95b47';

  Future<void> searchStocks(String query) async{
    searchQuery.value = query;
    if(query.length < 2 ){
      stocks.clear();
      return;
    }

    isLoading.value = true;
    try{
      final url = Uri.parse('https://api.twelvedata.com/symbol_search?symbol=$query&apikey=$apiKey');
      final response = await http.get(url);
      print(url);

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        final List results = data['data'] ?? [];

        final List<Stock> fetched = results.map((item) => Stock(name: item['instrument_name'] ?? '', symbol: item['symbol'] ?? '')).where((s) => s.name.isNotEmpty && s.symbol.isNotEmpty).toList();
        stocks.assignAll(fetched);
      }
      else{
        stocks.clear();
      }
    }catch(e){
      stocks.clear();
    }
    finally{
      isLoading.value = false;
    }
  }
}