import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Stock{
  final String symbol;
  final String company;

  Stock({required this.symbol, required this.company});

  Map<String, dynamic> toMap(){
    return {'symbol': symbol, 'company': company};
  }
  factory Stock.fromMap(Map<String, dynamic> map){
    return Stock(symbol: map['symbol'], company: map['company']);
  }
}

class WatchlistController extends GetxController{
  var watchlist = <Stock>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadWatchlist() async{
    final user = _auth.currentUser;
    if(user == null)return;

    final snapshot = await _firestore.collection('users').doc(user.uid).collection('watchlist').get();

    watchlist.value = snapshot.docs.map((doc) => Stock.fromMap(doc.data())).toList();
  }

  Future<void> addStock(String symbol, String company) async{
    final user = _auth.currentUser;
    if (user == null) return;
    final stock = Stock(symbol: symbol, company: company);



    if(!watchlist.any((s) => s.symbol == stock.symbol)){
      watchlist.add(stock);

      await _firestore.collection('users').doc(user.uid).collection('watchlist').doc(symbol).set(stock.toMap());
    }
  }

  Future<void> removeStock(String symbol) async {
    final user = _auth.currentUser;
    if (user == null) return;

    watchlist.removeWhere((s) => s.symbol == symbol);

    await _firestore.collection('users').doc(user.uid).collection('watchlist').doc(symbol).delete();
  }

  bool isInWatchlist(String symbol){
    return watchlist.any((s) => s.symbol == symbol);
  }
}