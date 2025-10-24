import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_predictor/controllers/chart_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class StockChartScreen extends StatelessWidget {
  final String symbol;
  final String company;
  const StockChartScreen({super.key, required this.symbol, required this.company});

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


          final data = controller.stockData.value;


          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: HexColor('181818'),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  height: screenHeight * 0.5,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //company
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

                          //symbol
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


                          //price
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
                          ),

                          //change
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Builder(
                              builder: (_) {
                                if (data == null) return const Text("-", style: TextStyle(color: Colors.white));

                                final change = data.change;
                                final pctChange = data.pctChange;

                                // Determine color based on positive or negative
                                final isPositive = change >= 0;
                                final color = isPositive ? Colors.greenAccent[400] : HexColor('ED0808');

                                // Add + sign if positive
                                final sign = isPositive ? "+" : "-";

                                return Text(
                                  "$sign${change.toStringAsFixed(2)} ($sign${pctChange.toStringAsFixed(2)}%)",
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),


                        ],
                      ),

                      //Line Chart
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

                      SizedBox(height: 20,),
                      //Range Selector
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
                          final selected = controller.selectedRange.value == r;
                          return ChoiceChip(
                            label: Text(label),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (_) => controller.changeRange(r),
                            selectedColor: HexColor('7DFDFE'),
                            backgroundColor: HexColor('181818'),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.transparent)),

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



              //details
              Padding(
                  padding: const EdgeInsets.all(20),
                child: controller.stockData.value == null
                    ? const SizedBox(height: 100)
                :Row(
                  children: [
                    Expanded(
                      child:Column(
                        spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          stockDetails("Exchange", data!.exchange),
                          stockDetails("Currency", data.currency),
                          stockDetails("Prev Close", data.prevClose.toStringAsFixed(4)),
                          stockDetails("Open", data.open.toStringAsFixed(4)),
                        ]
                      ),
                    ),
                    
                    Expanded(
                      child:Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          stockDetails("High", data.high.toStringAsFixed(4)),
                          stockDetails("Low", data.low.toStringAsFixed(4)),
                          stockDetails("52-wk high", data.high52.toStringAsFixed(4)),
                          stockDetails("52-wk low", data.low52.toStringAsFixed(4)),
                        ],
                      )
                    )
                  ],
                )
              )
            ],
          );
        }),
      ),
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
}
