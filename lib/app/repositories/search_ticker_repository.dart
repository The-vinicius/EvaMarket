import 'package:evamarket/app/data/ticker_datasource.dart';
import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/models/ticker_model.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/async_result.dart';

class SearchTickerRepository implements TickerRepository {
  final TickerDatasource dataSource;

  SearchTickerRepository(this.dataSource);

  @override
  AsyncResult<List<TickerModel>, DataException> fetchAll(String symbol) async {
    try {
      final data = await dataSource.getTickers(symbol);

      return Success(data);
    } catch (e) {
      return Failure(DataException('bom'));
    }
  }
}
