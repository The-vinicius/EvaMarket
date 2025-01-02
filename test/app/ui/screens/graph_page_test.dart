import 'package:evamarket/app/models/ticker_model.dart';
import 'package:evamarket/app/ui/screens/graph_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('graph page ...', (tester) async {
    final ticker = TickerModel(symbol: 'appl', name: 'asd');
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          settings = RouteSettings(name: '/graph', arguments: ticker);
          if (settings.name == '/graph') {
            return MaterialPageRoute(
                settings: settings, builder: (context) => const GraphPage());
          }
          return null;
        },
        initialRoute: '/graph',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Graph Screen'), findsOneWidget);
  });
}
