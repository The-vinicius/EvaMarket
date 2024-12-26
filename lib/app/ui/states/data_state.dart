import 'package:evamarket/app/interactor/store_stocks.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:flutter/foundation.dart';

final store = ValueNotifier<List<AssetModel>>([]);
final loading = ValueNotifier<bool>(false);
final error = ValueNotifier<String?>(null);
final stocks = StoreStocks();
