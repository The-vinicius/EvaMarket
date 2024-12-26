import 'package:evamarket/app/exceptions/exceptions.dart';
import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/interactor/actions/data_actions.dart';
import 'package:evamarket/app/models/asset_model.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:evamarket/app/ui/states/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/functions.dart';
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
  // Registre valores padrão no mocktail
  setUp(() {
    registerFallbackValue(AssetModel(ticker: 'asd', prices: [], dates: []));
    registerFallbackValue(DataException("Fallback error"));
  });
  test('data actions ...', () async {
    const String stock = 'asd';
    DateTime date = DateTime.now();
    // when(() => mockRepository.getDate(any(), any())).thenAnswer((_) async => Success(AssetModel(ticker: 'jaxa', prices: [], dates: []))
    // );
    await getStock(stock, date);
    expect(loading.value, false);
    expect(store.value.length, 1);
  });
}
