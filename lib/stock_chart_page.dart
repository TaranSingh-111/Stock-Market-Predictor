import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/chart_controller.dart';
import 'package:fl_chart/fl_chart.dart';


class StockChartPage extends StatelessWidget{
  final String symbol;
  final String company;
  const StockChartPage({super.key, required this.symbol, required this.company});

  String labelForIndex(ChartController controller, int index){
    final data = controller.currentData;
    final ts = data[index]['t']!.toInt() * 1000;
    final dt = DateTime.fromMillisecondsSinceEpoch(ts).toLocal();
    switch (controller.selectedRange.value){
      case RangeOption.oneDay:
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      default:
        return '${dt.day}/${dt.month}';
    }
  }

  @override
  Widget build(BuildContext context){
    final ChartController controller =Get.put(ChartController());
    controller.fetchLiveQuote(symbol);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Chart '),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx((){
              if(controller.spots.isEmpty){
                return const Center(child: CircularProgressIndicator(),);
              }

              final spots = controller.spots;
              final latest = controller.currentPrice.value == 0 ? spots.last.y : controller.currentPrice.value;
              final prev = spots.length > 1 ? spots[spots.length -2].y : latest;
              // final change = latest - prev;
              // final changePct = prev != 0 ? (change / prev) * 100 : 0.0;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(company, style: Theme.of(context).textTheme.titleLarge),
                              Text(symbol, style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${latest.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
                              Text(
                                '${controller.priceChange.value >=0 ? '+' : ''}${controller.priceChange.value.toStringAsFixed(2)} (${controller.priceChangePct.toStringAsFixed(2)}%)',
                                style: TextStyle(
                                    color: controller.priceChange >=0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ),
                      
                      const SizedBox(height: 25,),
                      SizedBox(
                        height: 260,
                        child: LineChart(
                          LineChartData(
                            minY: controller.minY.value,
                            maxY: controller.maxY.value,
                            gridData: FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true,reservedSize: 45, interval: (controller.maxY.value -controller.minY.value) /4)
                              ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true,reservedSize: 45, interval: (controller.maxY.value -controller.minY.value) /4)
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false,reservedSize: 45, interval: (controller.maxY.value -controller.minY.value) /4)
                                ),

                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, meta) {
                                    
                                    final index = v.toInt().clamp(0, max(0, spots.length -1));
                                    final step = (spots.length / 4).ceil();
                                    if(index % step !=0 && index != spots.length -1)
                                      return const SizedBox.shrink();
                                    final label = labelForIndex(controller, index.toInt());
                                    return Padding(padding: const EdgeInsets.only(top: 6), child: Text(label, style: const TextStyle(fontSize: 10)));
                                  })
                                )
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                curveSmoothness: 0.4,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                    ]
                                  )
                                ),

                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 2,
                              )
                            ]
                          )
                        ),
                      ),

                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Last updated: ${controller.lastUpdated.value}', style: Theme.of(context).textTheme.bodySmall,),
                          Row(children: [
                            const Text('Candlestick'),
                            Obx(() => Switch(
                              value: controller.isCandleStick.value,
                              onChanged: (v){
                                controller.isCandleStick.value = v;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Not Implemented'))
                                );
                              },
                            ))
                          ],)
                        ],
                      )

                    ],
                )
                )
              );
            }
            ),
            const SizedBox(height: 12,),
            Obx((){
              final options = RangeOption.values;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: options.map((opt){
                  final selected = opt == controller.selectedRange.value;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected ? Theme.of(context).colorScheme.primary: Colors.transparent,
                      foregroundColor: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () => controller.changeRange(opt),
                    child: Text(rangeLabel(opt)),
                  );
                }).toList(),
              );
            }),

            // const SizedBox(height: 24,),
            // Card(
            //   elevation: 0,
            //     child: Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: const[
            //           Text('Notes:', style: TextStyle(fontWeight: FontWeight.w600),),
            //         ],
            //       )
            //     ),
            // )
          ],
        ),
      ),

    );
  }
}
