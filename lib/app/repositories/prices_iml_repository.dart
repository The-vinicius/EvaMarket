import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/repositories/prices_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class PricesImlRepository implements PricesRepository {
  @override
  AsyncResult<List<double>, DataException> getPrices(String symbol) async {
    try {
      final data = await const YahooFinanceDailyReader()
          .getDailyDTOs(symbol, startDate: DateTime.now());
      final prices = [
        data.candlesData.first.open,
        data.candlesData.first.close
      ];
      return Success(prices);
    } catch (e) {
      return Failure(DataException('Error fetching prices'));
    }
  }
}
