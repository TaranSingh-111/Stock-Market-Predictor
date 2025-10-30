import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/screens/portfolio_screen.dart';
import 'package:stock_market_predictor/screens/watchlist_screen.dart';
import 'package:stock_market_predictor/screens/search_screen.dart';
import 'package:stock_market_predictor/screens/news_screen.dart';
import 'package:stock_market_predictor/screens/profile_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class MainController extends GetxController{
  var selectedIndex = 1.obs;

  final screens = [
    WatchlistScreen(),
    PortfolioScreen(),
    const StockSearchScreen(),
    const StockNewsScreen(),
    const ProfileScreen(),

  ];

  void onItemTapped(int index){
    selectedIndex.value = index;
  }
}

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context){
    final controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Colors.black,
      body:Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.onItemTapped,
        iconSize: 35,
        backgroundColor: Colors.black,
        selectedItemColor: HexColor('7DFDFE'),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart),label: '' ),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
        ]
      )),
    );
  }
}