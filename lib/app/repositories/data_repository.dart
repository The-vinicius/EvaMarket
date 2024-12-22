import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class DataRepository {
  AsyncResult<AssetModel, DataException> getDate(String ticker, DateTime date);
}
