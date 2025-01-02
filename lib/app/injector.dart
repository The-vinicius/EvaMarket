import 'package:auto_injector/auto_injector.dart';
import 'package:evamarket/app/data/ticker_datasource.dart';
import 'package:evamarket/app/repositories/data_repository.dart';
import 'package:evamarket/app/repositories/prices_iml_repository.dart';
import 'package:evamarket/app/repositories/prices_repository.dart';
import 'package:evamarket/app/repositories/search_ticker_repository.dart';
import 'package:evamarket/app/repositories/ticker_repository.dart';
import 'package:evamarket/app/repositories/yahoo_data_repository.dart';

final injector = AutoInjector();

void setupInjector() {
  injector.add<TickerDatasource>(TickerDatasource.new);
  injector.add<TickerRepository>(SearchTickerRepository.new);
  injector.add<DataRepository>(YahooDataRepository.new);
  injector.add<PricesRepository>(PricesImlRepository.new);
  injector.commit();
}
