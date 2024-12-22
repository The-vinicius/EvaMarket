import 'package:evamarket/app/models/asset_model.dart';
import 'package:flutter/foundation.dart';

final stocks = ValueNotifier<List<AssetModel>>([]);
final loading = ValueNotifier<bool>(false);
final error = ValueNotifier<String?>(null);
