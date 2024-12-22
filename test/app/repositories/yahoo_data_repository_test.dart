import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/repositories/yahoo_data_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('yahoo return assetModel success', () async {
    final repository = YahooDataRepository();
    final assetModel = await repository.getDate('GOOG', DateTime.now());
    expect(assetModel.isSuccess(), true);
  });
  //nake test fail
  test('yahoo return assetModel failure', () async {
    final repository = YahooDataRepository();
    final assetModel = await repository.getDate('picademel', DateTime.now());
    expect(assetModel.isError(), true);
  });
}

