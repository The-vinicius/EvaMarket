import 'dart:convert';

import 'package:http/http.dart' as http;

class TickerDatasource {
  Future<List<Map<String, String>>> getTickers(String query) async {
    final _apiKey = 'key_pass';
    final url = Uri.parse(
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['bestMatches'];
      final tickers = <Map<String, String>>[];
      for (final item in data) {
        tickers.add({
          'symbol': item['1. symbol'],
          'name': item['2. name'],
        });
      }
      return tickers;
    } else {
      throw Exception('Failed to load tickers');
    }
  }
}
