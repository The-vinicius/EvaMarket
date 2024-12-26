import 'package:evamarket/app/interactor/store_search.dart';
import 'package:evamarket/app/ui/states/data_state.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchTab> {
  final store = StoreSearch();
  final TextEditingController _controller = TextEditingController();

  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: store,
        builder: (context, w) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: (query) async => await store.search(query),
                  decoration: const InputDecoration(
                    labelText: 'Buscar Ticker',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                if (store.isLoading)
                  const CircularProgressIndicator()
                else
                  Expanded(
                    child: store.hasError
                        ? Center(
                            child: Text(store.errorMessage),
                          )
                        : ListView.builder(
                            itemCount: store.stores.length,
                            itemBuilder: (context, index) {
                              final result = store.stores[index];
                              return ListTile(
                                title: Text(result.symbol),
                                subtitle: Text(result.name),
                                onTap: () async {
                                  await stocks.getStock(
                                      result.symbol, DateTime(now.year - 1));
                                  Navigator.of(context)
                                      .pushNamed('/graph', arguments: result);
                                },
                              );
                            },
                          ),
                  ),
              ],
            ),
          );
        });
  }
}
