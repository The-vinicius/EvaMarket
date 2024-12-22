import 'package:evamarket/app/injector.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:evamarket/app/ui/states/data_state.dart';

Future<void> getStock(String stock, DateTime date) async {
  loading.value = true;
  final repository = injector.get<DataRepository>();
  final result = await repository.getDate(stock, date);
  result.fold((result) {
    stocks.value.add(result);
  }, (e) {
    error.value = 'error';
  });
  loading.value = false;
}
