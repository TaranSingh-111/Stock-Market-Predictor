import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_predictor/controllers/chart_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stock_market_predictor/controllers/watchlist_controller.dart';
import 'package:stock_market_predictor/controllers/portfolio_controller.dart';

class StockChartScreen extends StatelessWidget {
  final String symbol;
  final String company;
  StockChartScreen({super.key, required this.symbol, required this.company});

  final WatchlistController watchlistController = Get.find<WatchlistController>();
  final PortfolioController portfolioController = Get.find<PortfolioController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartController(symbol));
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Obx(() {
        if (controller.candles.isEmpty) {
          return const Center(
            child: SpinKitWaveSpinner(
              color: Color(0xFF7DFDFE),
              size: 100,
              duration: Duration(milliseconds: 1500),
            ),
          );
        }

        final spots = controller.candles.map((c) {
          final t = (c['time'] as int).toDouble();
          final price = (c['close'] as double);
          return FlSpot(t, price);
        }).toList();

        final minX = spots.first.x;
        final chartSpots =
        spots.map((s) => FlSpot((s.x - minX) / 1000000, s.y)).toList();

        final data = controller.stockData.value;
        final screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120), // space for button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: HexColor('181818'),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.48,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(company,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(symbol,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${controller.currentPrice.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: HexColor('7DFDFE'),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Builder(builder: (_) {
                                    if (data == null) {
                                      return const Text("-", style: TextStyle(color: Colors.white));
                                    }
                                    final change = data.change;
                                    final pctChange = data.pctChange;
                                    final isPositive = change >= 0;
                                    final color = isPositive
                                        ? Colors.greenAccent[400]
                                        : Colors.redAccent[400];
                                    final sign = isPositive ? "+" : "";
                                    return Text(
                                      "$sign${change.toStringAsFixed(2)} ($sign${pctChange.toStringAsFixed(2)}%)",
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: const FlTitlesData(show: false),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: chartSpots,
                                          isCurved: true,
                                          color: HexColor('7DFDFE'),
                                          barWidth: 2.5,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                HexColor('7DFDFE').withOpacity(0.5),
                                                Colors.transparent
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: RangeOption.values.map((r) {
                                  final label = switch (r) {
                                    RangeOption.threeHours => '3H',
                                    RangeOption.oneDay => '1D',
                                    RangeOption.oneWeek => '1W',
                                    RangeOption.oneMonth => '1M',
                                    RangeOption.threeMonths => '3M',
                                    RangeOption.oneYear => '1Y',
                                  };
                                  final selected =
                                      controller.selectedRange.value == r;
                                  return ChoiceChip(
                                    label: Text(label),
                                    selected: selected,
                                    showCheckmark: false,
                                    onSelected: (_) => controller.changeRange(r),
                                    selectedColor: HexColor('7DFDFE'),
                                    backgroundColor: HexColor('181818'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    labelStyle: TextStyle(
                                      color:
                                      selected ? Colors.black : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Obx(() {
                            final isInList =
                            watchlistController.isInWatchlist(symbol);
                            return IconButton(
                              icon: Icon(
                                isInList ? Icons.star : Icons.star_border,
                                color: isInList
                                    ? Colors.yellowAccent
                                    : Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                if (isInList) {
                                  watchlistController.removeStock(symbol);
                                  Get.snackbar("Removed",
                                      "$company removed from watchlist");
                                } else {
                                  watchlistController.addStock(symbol, company);
                                  Get.snackbar("Added",
                                      "$company added to watchlist");
                                }
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  // Stock details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: controller.stockData.value == null
                        ? const SizedBox(height: 100)
                        : Row(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              stockDetails("Exchange", data!.exchange),
                              stockDetails("Currency", data.currency),
                              stockDetails("Prev Close",
                                  data.prevClose.toStringAsFixed(4)),
                              stockDetails(
                                  "Open", data.open.toStringAsFixed(4)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              stockDetails(
                                  "High", data.high.toStringAsFixed(4)),
                              stockDetails("Low", data.low.toStringAsFixed(4)),
                              stockDetails("52-wk high",
                                  data.high52.toStringAsFixed(4)),
                              stockDetails("52-wk low",
                                  data.low52.toStringAsFixed(4)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: ),



            Positioned(
              bottom: 10,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // buy button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: Colors.greenAccent.withOpacity(0.8),
                    ),
                    onPressed: () {
                      _showTradeDialog(context, 'BUY', symbol, company, controller.currentPrice.value );
                    },
                    child: const Text(
                      "BUY",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 8),
                  //sell button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: Colors.redAccent.withOpacity(0.8),
                    ),
                    onPressed: () {
                      _showTradeDialog(context, 'SELL', symbol, company, controller.currentPrice.value);
                    },
                    child: const Text(
                      "SELL",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),


                ],
              )
            ),


            // Predict Button
            Positioned(
              bottom: 40,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Get.snackbar("Predict", "Prediction feature coming soon!");
                },
                child: Container(
                  height: 55,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        HexColor('#F8D71A'),
                        HexColor('#C79D17'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Predict',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }


  Widget stockDetails(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title :', style: TextStyle(color: Colors.white, fontSize: 15)),
        SizedBox(width: 10),
        Text(value, style: TextStyle(color: HexColor('7DFDFE'), fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
    return SizedBox(height: 20);
  }

  void _showTradeDialog(BuildContext context, String action, String symbol, String company, double price) {
    final TextEditingController quantityController = TextEditingController();
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "$action Stock",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: action == "BUY" ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Enter Quantity",
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: action == "BUY"
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: action == "BUY"
                      ? Colors.greenAccent.shade400
                      : Colors.redAccent.shade400,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final text = quantityController.text.trim();
                  if (text.isEmpty) {
                    Get.snackbar("Empty", "Please enter a quantity");
                    return;
                  }

                  final int? quantity = int.tryParse(text);

                  if (quantity == null || quantity <= 0) {
                    Get.snackbar("Invalid", "Enter a valid quantity");
                    return;
                  }
                  
                  
                  
                  if(action == "BUY"){
                    portfolioController.buyStock(symbol, company, price, quantity );
                  }
                  else{
                    portfolioController.sellStock(symbol, price, quantity);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  action == "BUY" ? "Confirm Purchase" : "Confirm Sell",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
