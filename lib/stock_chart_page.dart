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
      appBar: AppBar(
        title: Text('$symbol Chart'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: HexColor('181818'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.candles.isEmpty) {
          return const Center(child: Text('No data', style: TextStyle(color: Colors.white)));
        }

        final spots = controller.candles.map((c) {
          final t = (c['time'] as int).toDouble();
          final price = (c['close'] as num).toDouble();
          return FlSpot(t, price);
        }).toList();

        final minX = spots.first.x;
        final chartSpots = spots
            .map((s) => FlSpot((s.x - minX) / (1000 * 60 * 60), s.y))
            .toList();

        return Column(
          children: [
            const SizedBox(height: 10),
            Text(
              '\$${controller.currentPrice.value.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartSpots,
                        isCurved: true,
                        color: HexColor('5BE6E0'),
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        barWidth: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Wrap(
                spacing: 10,
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
                    onSelected: (_) => controller.changeRange(r),
                    selectedColor: HexColor('5BE6E0'),
                    backgroundColor: HexColor('181818'),
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        );
      }),
    );
  }
}
