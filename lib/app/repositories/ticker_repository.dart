import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/models/ticker_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class TickerRepository {
  AsyncResult<List<TickerModel>, DataException> fetchAll(String symbol);
}
