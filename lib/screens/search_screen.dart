import 'dart:convert';
import 'package:flutter/material.dart'  hide SearchController;
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stock_market_predictor/controllers/search_controller.dart';
import 'package:stock_market_predictor/screens/stock_chart_screen.dart';

class StockSearchScreen extends StatelessWidget{
  const StockSearchScreen({super.key});

  @override
  Widget build(BuildContext context){
    final controller = Get.put(SearchController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search Stocks', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search stock by name or symbol...',
                  hintStyle: TextStyle(color:  Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                  )
                ),
                onChanged: (value) => controller.searchStocks(value),
              ),
          ),

          Expanded(
              child: Obx((){
                  if(controller.stocks.isEmpty && controller.searchQuery.value.isNotEmpty){
                    return const Center(
                      child: Text('No results found', style: TextStyle(color: Colors.grey),)
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.stocks.length,
                    itemBuilder:  (context, index){
                      final stock = controller.stocks[index];
                      return ListTile(
                        title: Text(stock.name, style: TextStyle(color: Colors.white)),
                        subtitle: Text(stock.symbol, style: TextStyle(color: HexColor('181818'))),
                        onTap: (){
                            Get.to(StockChartScreen(symbol: stock.symbol, company: stock.name));
                        },
                      );
                    }
                  );
                }
              )
          )
        ],
      ),
    );
  }
}