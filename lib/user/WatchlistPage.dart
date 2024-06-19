import 'package:flutter/material.dart';
import 'StockData.dart'; // Pastikan path ini sesuai dengan proyek Anda
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPage();
}

class _WatchlistPage extends State<WatchlistPage> {
  List<StockData> stocks = List.empty(growable: true);
  Future<StockData>? req;
  late List<StockData> data;
  late TextEditingController _controller;
  late String symbol;
  List<String>? stocksIncluded;

  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    req = StockData.fetchStockData("");
    retrieveList();
    symbol = "";
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Market Stocks'),
        backgroundColor:
            Colors.lightBlueAccent, // Ubah warna latar belakang app bar
        actions: [
          IconButton(
            onPressed: () {
              data.clear();
              stocksIncluded!.clear();
              symbol = "";
              req = StockData.fetchStockData(symbol);
              saveList();
              setState(() {});
            },
            icon: Icon(Icons.delete,
                color: Colors.red), // Ubah warna ikon menjadi merah
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              key: const ValueKey("searchBar"),
              onEditingComplete: sendSearch,
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: TextButton(
                  key: const ValueKey("searchButton"), // Untuk uji UI
                  onPressed: sendSearch,
                  child: const Text('Add', style: TextStyle(fontSize: 20)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(child: stocksOutput()),
        ],
      ),
    );
  }

  FutureBuilder<StockData> stocksOutput() {
    return FutureBuilder<StockData>(
      future: req,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (snapshot.data!.symbol != "NONE") {
            if (!stocksIncluded!.contains(snapshot.data!.symbol)) {
              data.add(snapshot.data!);
              stocksIncluded!.add(snapshot.data!.symbol);
              saveList();
            }
          }
          return displayData();
        } else {
          return displayData();
        }
      },
    );
  }

  Expanded displayData() {
    return Expanded(
      child: ReorderableListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.grey.shade200, // Ubah warna latar belakang tile
            key: ValueKey(index),
            contentPadding: const EdgeInsets.all(10),
            title: Text(data[index].symbol),
            subtitle: Text(data[index].name),
            trailing: IconButton(
              onPressed: () {
                data.removeAt(index);
                stocksIncluded!.removeAt(index);
                symbol = "";
                req = StockData.fetchStockData(symbol);
                saveList();
                setState(() {});
              },
              icon: Icon(Icons.remove,
                  color: Colors.red), // Ubah warna ikon menjadi merah
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          final StockData d = data.removeAt(oldIndex);
          final String n = stocksIncluded!.removeAt(oldIndex);

          data.insert(newIndex, d);
          stocksIncluded!.insert(newIndex, n);
          symbol = "";
          req = StockData.fetchStockData(symbol);
          saveList();
          setState(() {});
        },
      ),
    );
  }

  void sendSearch() {
    symbol = _controller.text.toUpperCase();
    if (!stocksIncluded!.contains(symbol)) {
      req = StockData.fetchStockData(symbol);

      // Tutup keyboard saat menekan tombol "Add"
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});
    }

    _controller.clear();
  }

  Future<void> saveList() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('data', stocksIncluded!);
  }

  Future<void> retrieveList() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    stocksIncluded = pref.getStringList('data');
    stocksIncluded ??= List.empty(growable: true);
    stocksIncluded = stocksIncluded!.toSet().toList();
    for (int i = 0; i < stocksIncluded!.length; i++) {
      symbol = stocksIncluded![i];
      data.add(await StockData.fetchStockData(symbol));
    }
    setState(() {});
  }
}
