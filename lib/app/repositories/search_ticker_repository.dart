import 'package:evamarket/app/data/ticker_datasource.dart';
import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/async_result.dart';

class SearchTickerRepository implements TickerRepository {
  final TickerDatasource _dataSource;

  SearchTickerRepository(this._dataSource);

  @override
  AsyncResult<List<Map<String, String>>, DataException> fetchAll(
      String symbol) async {
    try {
      final data = await _dataSource.getTickers(symbol);
      return Success(data);
    } catch (e) {
      return Failure(DataException(''));
    }
  }
}
