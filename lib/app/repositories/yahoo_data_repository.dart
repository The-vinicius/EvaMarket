import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/async_result.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class YahooDataRepository implements DataRepository {
  @override
  AsyncResult<AssetModel, DataException> getDate(
      String ticker, DateTime date) async {
    try {
      final data = await const YahooFinanceDailyReader()
          .getDailyDTOs(ticker, startDate: date);
      final prices = data.candlesData.map((candle) => candle.close).toList();
      final dates = data.candlesData.map((candle) => candle.date).toList();
      return Success(AssetModel(ticker: ticker, prices: prices, dates: dates));
    } catch (e) {
      return Failure(DataException('Error data'));
    }
  }
}
