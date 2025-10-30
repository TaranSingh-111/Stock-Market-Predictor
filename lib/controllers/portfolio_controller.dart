import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:stock_market_predictor/services/stock_service.dart';

class PortfolioController extends GetxController{
  var balance = 50000.0.obs;
  var holdings = <Map<String, dynamic>>[].obs;
  var totalInvestment = 0.0.obs;
  var totalValue = 0.0.obs;

  final _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void onInit(){
    super.onInit();
    loadPortfolio();
    updateTotalValue();
    ever(holdings, (_) => updateTotalValue());
  }

  Future<void> loadPortfolio() async{
    // holdings.value = [
    //   {"symbol": "INFY", "company": "Infosys Ltd", "quantity": 10, "gain": 5.4, 'value': 40.0, 'color': Colors.blue},
    //   {"symbol": "TCS", "company": "Tata Consultancy Services", "quantity": 5, "gain": -2.1, 'value': 30.0, 'color': Colors.green},
    //   {"symbol": "HDFC", "company": "HDFC Bank Ltd", "quantity": 7, "gain": 3.9, 'value': 30.0, 'color': Colors.orange},
    // ];
    // totalInvestment.value= 204377;
    // totalValue.value = 245300;

    final doc = await _firestore.collection('users').doc(userId).get();
    if(doc.exists){
      balance.value = doc['balance'];
      totalInvestment.value = doc['totalInvestment'];
      holdings.value = List<Map<String, dynamic>>.from(doc['holdings']);
      totalValue = calculateTotalValue(holdings) as RxDouble;
    }
  }


  //--------buy stock

  //assign color
  final _random = Random();

  Color getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(200),
      _random.nextInt(200),
      255, // bluish tint
    );
  }


  Future<void> buyStock(String symbol, String company, double price, int quantity) async{
    final cost = price * quantity;
    if (balance.value < cost) return;

    balance.value -= cost;

    final existing = holdings.firstWhereOrNull((h) => h['symbol'] == symbol);
    if (existing != null) {
      existing['quantity'] += quantity;
      existing['avgBuyPrice'] = ((existing['avgBuyPrice'] * (existing['quantity'] - quantity)) + cost) / existing['quantity'];
    } else {
      final color = getRandomColor();
      holdings.add({
        "symbol": symbol,
        "company": company,
        "quantity": quantity,
        "avgBuyPrice": price,
        "color": color.value,
      });
    }

    totalInvestment.value += cost;
    await updateTotalValue();
    await savePortfolio();
  }

  //-------sell stock

  Future<void> sellStock(String symbol, double price, int quantity) async {
    final existing = holdings.firstWhereOrNull((h) => h['symbol'] == symbol);
    if (existing == null || existing['quantity'] < quantity) return;

    final revenue = price * quantity;
    balance.value += revenue;
    existing['quantity'] -= quantity;

    if (existing['quantity'] == 0) holdings.remove(existing);

    totalInvestment.value -= revenue;
    await updateTotalValue();
    await savePortfolio();
  }


  Future<void> savePortfolio() async {
    await _firestore.collection('users').doc(userId).update({
      "balance": balance.value,
      "totalInvestment": totalInvestment.value,
      "holdings": holdings,
    });
  }

  double calculateTotalValue(List<dynamic> holdings) {
    double total = 0.0;

    for (var stock in holdings) {
      final quantity = (stock['quantity'] ?? 0).toDouble();
      final currentPrice = (stock['currentPrice'] ?? 0).toDouble();

      total += quantity * currentPrice;
    }

    return total;
  }



   final _service = StockService();
  Future<void> updateTotalValue() async {
    double total = 0.0;

    for (var stock in holdings) {
      try {
        // fetch live price using your service
        final double? currentPrice = await _service.getQuote(stock['symbol']);
        if (currentPrice != null) {
          total += currentPrice * (stock['quantity'] ?? 0);
        }
      } catch (e) {
        print("Error fetching price for ${stock['symbol']}: $e");
      }
    }

    totalValue.value = total;
  }



}