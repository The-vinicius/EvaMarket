import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:evamarket/app/ui/screens/home_screen.dart';
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
void main() {
  late MockDataRepository mockRepository;
  setUpAll(() {
    mockRepository = MockDataRepository();
    injector.add<DataRepository>(MockDataRepository.new);
    injector.addInstance(mockRepository);
    injector.commit();
  });
  testWidgets('Home screen done', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: HomeScreen(),));
    expect(find.byKey(const Key('Sem')), findsOneWidget);
  });

  testWidgets('Home screen done', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: HomeScreen(),));
    expect(find.byKey(const Key('Sem')), findsOneWidget);
    await widgetTester.tap(find.byKey(const Key('stock')));
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('price')), findsOneWidget);
  });
}