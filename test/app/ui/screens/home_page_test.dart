import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:evamarket/app/models/ticker_model.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:evamarket/app/repositories/prices_repository.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:evamarket/app/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result_dart/result_dart.dart';

class MockDataRepository implements DataRepository {
  @override
  AsyncResult<AssetModel, DataException> getDate(String ticker, DateTime date) {
    AsyncResult<AssetModel, DataException> result = AsyncResult.sync(() {
      return Success(AssetModel(ticker: 'goas', prices: [], dates: []));
    });
    return result;
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class MockTickerRepository implements TickerRepository {
  @override
  AsyncResult<List<TickerModel>, DataException> fetchAll(String symbol) {
    AsyncResult<List<TickerModel>, DataException> result = AsyncResult.sync(() {
      return Success([TickerModel(name: 'bitcin', symbol: 'BTC-USD')]);
    });
    return result;
  }

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class MockPricesRepository implements PricesRepository {
  @override
  AsyncResult<List<double>, DataException> getPrices(String symbol) {
    return AsyncResult.sync(() => const Success([2, 4]));
  }
}

void main() {
  late MockDataRepository mockRepository;

  setUpAll(() {
    mockRepository = MockDataRepository();
    injector.add<DataRepository>(MockDataRepository.new);
    injector.addInstance(mockRepository);
    injector.add<PricesRepository>(MockPricesRepository.new);
    injector.add<TickerRepository>(MockTickerRepository.new);
    injector.commit();
  });
  testWidgets('Home screen done', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));
    expect(find.byKey(const Key('home')), findsOneWidget);
  });

  testWidgets('Home screen done', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));
    await widgetTester.tap(find.byKey(const Key('search')));
    await widgetTester.pumpAndSettle();
    final ticker = find.byKey(const Key('search_key'));
    await widgetTester.tap(ticker);
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(ticker, 'bitcoin');
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('ticker_key')), findsOneWidget);
  });
}

