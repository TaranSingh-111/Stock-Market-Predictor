import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsController extends GetxController{
  var newsList = <dynamic>[].obs;
  var isLoading = true.obs;

  Future<void> fetchNews() async{
    const apiKey = 'd3qveg9r01qna05k3kfgd3qveg9r01qna05k3kg0';
    const url = 'https://finnhub.io/api/v1/news?category=general&token=$apiKey';

    try{
      isLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        newsList.value = jsonDecode(response.body);
      }
      else{
        throw Exception('Failed to lead news');
      }
    }
    catch(e){
      print('Error: $e');
    }
    finally{
      isLoading.value = false;
    }
  }
}