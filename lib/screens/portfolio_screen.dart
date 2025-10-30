import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stock_market_predictor/controllers/portfolio_controller.dart';
import 'package:stock_market_predictor/screens/stock_chart_screen.dart';
import 'package:stock_market_predictor/controllers/chart_controller.dart';

class PortfolioScreen extends StatelessWidget{
  final PortfolioController controller = Get.put(PortfolioController());

  PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Portfolio', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx((){
          final totalValue = controller.totalValue.value ?? 0.0;
          final totalInvestment = controller.totalInvestment.value ?? 0.0;

          final gain = totalValue - totalInvestment;
          final gainPercent = totalInvestment == 0 ? 0 : (gain / totalInvestment) * 100;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HexColor('181818'),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _summaryItem('Total Investment', '\$${controller.totalInvestment.value.toStringAsFixed(2)}'),
                          _summaryItem('Total Value', '\$${controller.totalValue.value.toStringAsFixed(2)}')
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${((gain ?? 0) >= 0 ? '+' : '-')} \$${((gain ?? 0).abs().toStringAsFixed(2))} (${gainPercent.toStringAsFixed(2)}%)",
                        style: TextStyle(
                          color: gain >=0 ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HexColor('181818'),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sections: controller.holdings.map((h){
                        return PieChartSectionData(
                          value: h['value'],
                          title: h['symbol'],
                          color: Color(h['color']),
                          radius: 60,
                          titleStyle: const TextStyle(color: Colors.white, fontSize: 12)
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),

                SizedBox(height: 8,),

                const Text(
                  'Your Holdings',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Column(
                  children: controller.holdings.map((stock) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: HexColor('181818'),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          stock['symbol'],
                          style: TextStyle(color: HexColor('7DFDFE'), fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Quantity: ${stock['quantity']}',
                          style: TextStyle(color: Colors.white),
                        ),

                        trailing: Text(
                          '${((stock['gain'] ?? 0) > 0 ? '+' : '')}${(stock['gain'] ?? 0).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: ((stock['gain'] ?? 0) >= 0) ? Colors.greenAccent : Colors.redAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),

                        onTap: () {
                          Get.to(StockChartScreen(
                            symbol: stock['symbol'],
                            company: stock['company'],
                          ));
                        },
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _summaryItem(String title, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: HexColor('7DFDFE'), fontSize: 18, fontWeight: FontWeight.bold))
      ],
    );
  }
}