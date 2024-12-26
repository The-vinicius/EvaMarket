class TickerModel {
  final String symbol;
  final String name;

  TickerModel({required this.symbol, required this.name});

  factory TickerModel.fromJson(Map<String, dynamic> json) {
    return TickerModel(
      symbol: json['symbol'],
      name: json['name'],
    );
  }
}
