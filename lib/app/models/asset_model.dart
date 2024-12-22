class AssetModel {
  final String ticker;
  final List<double> prices;
  final List<DateTime> dates;

  AssetModel({required this.ticker, required this.prices, required this.dates});

  static AssetModel empyt() {
    return AssetModel(ticker: '', prices: [], dates: []);
  }
}
