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
                cursorColor: HexColor('7DFDFE'),
                decoration: InputDecoration(
                  hintText: 'Search stock by name or symbol...',
                  hintStyle: TextStyle(color:  Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  prefixIcon: Icon(Icons.search, color: HexColor('7DFDFE')),
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

                  return ListView.separated(
                    itemCount: controller.stocks.length,
                    itemBuilder:  (context, index){
                      final stock = controller.stocks[index];
                      return ListTile(
                        title: Text(stock.name, style: TextStyle(color: Colors.white)),
                        subtitle: Text(stock.symbol, style: TextStyle(color: Colors.grey[400])),
                        onTap: (){
                            Get.to(StockChartScreen(symbol: stock.symbol, company: stock.name));
                        },
                      );
                    },
                    separatorBuilder: (context, index){
                      return Container(
                        height: 2,
                        color: HexColor('7DFDFE').withOpacity(0.3),
                      );
                    },
                  );
                }
              )
          )
        ],
      ),
    );
  }
}