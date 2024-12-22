import 'package:evamarket/app/data/ticker_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TickerDatasource dataSource = TickerDatasource();
  test('ticker datasource ...', () async {
    final data = await dataSource.getTickers('bitcoin');
    expect(data.length, greaterThan(1));
  });  
}