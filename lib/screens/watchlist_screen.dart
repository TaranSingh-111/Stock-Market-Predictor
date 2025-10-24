import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/controllers/watchlist_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stock_market_predictor/screens/stock_chart_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>{


  final WatchlistController controller = Get.put(WatchlistController());
  final TextEditingController stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadWatchlist();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Watchlist', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding:const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.watchlist.isEmpty) {
            return const Center(
              child: Text(
                'No stock in watchlist',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.watchlist.length,
            itemBuilder: (context, index) {
              final stock = controller.watchlist[index];
              return Card(
                elevation: 3,
                shadowColor: HexColor('7DFDFE'),
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.show_chart, color: HexColor('7DFDFE')),
                  title: Text(
                    stock.symbol,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    stock.company,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.removeStock(stock.symbol);
                    },
                  ),
                  onTap: () {
                    Get.to(StockChartScreen(
                      symbol: stock.symbol,
                      company: stock.company,
                    ));
                  },
                ),
              );
            },
          );
        }),
      )
    );
  }
}