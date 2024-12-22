import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:result_dart/result_dart.dart';

abstract class TickerRepository {
  AsyncResult<List<Map<String, String>>, DataException> fetchAll(String symbol);
}
