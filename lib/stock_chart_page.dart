import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_predictor/chart_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class StockChartPage extends StatelessWidget {
  final String symbol;
  final String company;
  const StockChartPage({super.key, required this.symbol, required this.company});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartController(symbol));
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,

      ),
      body: Center(
        child: Obx(() {
          // if (controller.isLoading.value) {
          //   return const CircularProgressIndicator(color: Colors.greenAccent);
          // }

          if (controller.candles.isEmpty) {
            return const Text(
              'No Data Available',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            );
          }

          // Build chart points
          final spots = controller.candles.map((c) {
            final t = (c['time'] as int).toDouble();
            final price = (c['close'] as double);
            return FlSpot(t, price);
          }).toList();

          final minX = spots.first.x;
          final chartSpots =
          spots.map((s) => FlSpot((s.x - minX) / 1000000, s.y)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: HexColor('181818'),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: screenHeight * 0.45,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Current Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              company,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,


                              ),
                            ),
                          ),


                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                  symbol,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,

                                  ),
                              ),
                          ),

                          const SizedBox(height: 6),
                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                            child: Text(
                            '\$${controller.currentPrice.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: HexColor('7DFDFE'),
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          )
                        ],
                      ),

                      // --- Line Chart ---
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // --- Range Selector ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: RangeOption.values.map((r) {
                          final label = switch (r) {
                            RangeOption.oneDay => '1D',
                            RangeOption.oneWeek => '1W',
                            RangeOption.oneMonth => '1M',
                            RangeOption.oneYear => '1Y',
                          };
                          final selected = controller.selectedRange.value == r;
                          return ChoiceChip(
                            label: Text(label),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (_) => controller.changeRange(r),
                            selectedColor: HexColor('7DFDFE'),
                            backgroundColor: Colors.grey[850],
                            labelStyle: TextStyle(
                              color: selected ? Colors.black : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
