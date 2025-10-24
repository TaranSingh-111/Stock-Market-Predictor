import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stock_market_predictor/controllers/news_controller.dart';

class StockNewsScreen extends StatelessWidget{
  const StockNewsScreen({super.key});

  void openArticle(String url) async {
    if (url.isEmpty) {
      Get.snackbar('Error', 'No article URL found');
      return;
    }

    final Uri uri = Uri.parse(url);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar('Error', 'Could not open the article');
      }
    } catch (e) {
      print('Launch error: $e');
      Get.snackbar('Error', 'Something went wrong while opening the link');
    }
  }


  @override
  Widget build(BuildContext context){
    final NewsController controller = Get.put(NewsController());
    controller.fetchNews();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Market News', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Obx((){

        final news = controller.newsList;
        return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index){
              final article = news[index];

              return GestureDetector(
                onTap: () => openArticle(article['url']),
                child: Card(
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.network(
                          article['image'] ?? '',
                          width: 120,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          Container(width: 120, height: 100, color: Colors.grey[800]),
                        ),
                      ),

                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['headline'] ?? 'No title',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  article['summary'] ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.3),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article['source'] ?? '',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic)
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              );
            }
        );
      })
    );
  }
}