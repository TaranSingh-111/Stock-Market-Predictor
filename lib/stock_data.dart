class StockData{
  final double open;
  final double high;
  final double low;
  final String exchange;
  final String currency;
  final double high52;
  final double low52;
  final double dividend;
  final double qtrDivAmt;
  final double prevClose;
  final double change;
  final double pctChange;

  StockData({
    required this.open,
    required this.high,
    required this.low,
    required this.exchange,
    required this.currency,
    required this.high52,
    required this.low52,
    required this.dividend,
    required this.qtrDivAmt,
    required this.prevClose,
    required this.change,
    required this.pctChange
  });
}