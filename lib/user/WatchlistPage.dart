import 'package:flutter/material.dart';
import 'StockData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stocks_card.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  TextEditingController _controller = TextEditingController();
  List<String> stocksIncluded = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    stocksIncluded = await retrieveList();
    setState(() {});
  }

  Future<List<String>> retrieveList() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? stocksIncluded = pref.getStringList('data');
    stocksIncluded ??= List.empty(growable: true);
    return stocksIncluded.toSet().toList();
  }

  Future<void> saveList(List<String> stocksIncluded) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('data', stocksIncluded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Market Stocks'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              stocksIncluded.clear();
              await saveList(stocksIncluded);
              setState(() {});
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              key: const ValueKey("searchBar"),
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: TextButton(
                  key: const ValueKey("searchButton"),
                  onPressed: () async {
                    String symbol = _controller.text.toUpperCase();
                    if (!stocksIncluded.contains(symbol)) {
                      try {
                        StockData stock =
                            await StockData.fetchStockData(symbol);
                        if (stock.symbol != "NONE") {
                          stocksIncluded.add(symbol);
                          await saveList(stocksIncluded);
                          setState(() {});
                        }
                      } catch (e) {
                        print("Error fetching stock data: $e");
                      }
                    }
                    _controller.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Text('Add', style: TextStyle(fontSize: 20)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StockData>>(
              future: Future.wait(stocksIncluded
                  .map((symbol) => StockData.fetchStockData(symbol))
                  .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<StockData> data = snapshot.data!;
                  return ReorderableListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return StockCard(
                        key: ValueKey(index),
                        stock: data[index],
                      );
                    },
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      final String item = stocksIncluded.removeAt(oldIndex);
                      stocksIncluded.insert(newIndex, item);
                      await saveList(stocksIncluded);
                      setState(() {});
                    },
                  );
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
