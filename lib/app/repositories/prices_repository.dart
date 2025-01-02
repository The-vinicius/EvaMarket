import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:result_dart/result_dart.dart';

abstract class PricesRepository {
  AsyncResult<List<double>, DataException> getPrices(String symbol);
}
