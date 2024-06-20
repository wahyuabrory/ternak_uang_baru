import 'package:flutter/material.dart';
import '../user/StockData.dart'; // Import file StockData.dart yang berisi model data saham
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences untuk menyimpan data lokal

// Class WatchlistPage adalah StatefulWidget yang menampilkan halaman watchlist saham
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

// State dari WatchlistPage
class _WatchlistPageState extends State<WatchlistPage> {
  TextEditingController _controller =
      TextEditingController(); // Controller untuk input teks pada TextField
  List<String> stocksIncluded =
      []; // List untuk menyimpan simbol saham yang disimpan dalam watchlist

  @override
  void initState() {
    super.initState();
    _loadWatchlist(); // Memuat watchlist saat initState dipanggil
  }

  // Method async untuk memuat watchlist dari SharedPreferences
  Future<void> _loadWatchlist() async {
    stocksIncluded =
        await retrieveList(); // Memuat daftar saham dari SharedPreferences
    setState(() {}); // Memperbarui state untuk membangun ulang UI
  }

  // Method async untuk mengambil daftar saham dari SharedPreferences
  Future<List<String>> retrieveList() async {
    final SharedPreferences pref = await SharedPreferences
        .getInstance(); // Mendapatkan instance SharedPreferences
    List<String>? stocksIncluded = pref
        .getStringList('data'); // Mengambil daftar saham dari SharedPreferences
    stocksIncluded ??= List.empty(
        growable: true); // Jika null, inisialisasi dengan list kosong
    return stocksIncluded
        .toSet()
        .toList(); // Mengembalikan list setelah diubah ke list dan dihapus duplikatnya
  }

  // Method async untuk menyimpan daftar saham ke SharedPreferences
  Future<void> saveList(List<String> stocksIncluded) async {
    final SharedPreferences pref = await SharedPreferences
        .getInstance(); // Mendapatkan instance SharedPreferences
    pref.setStringList(
        'data', stocksIncluded); // Menyimpan daftar saham ke SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Market Stocks'), // Judul AppBar
        backgroundColor: Colors.lightBlueAccent, // Warna latar belakang AppBar
        actions: [
          IconButton(
            onPressed: () async {
              stocksIncluded.clear(); // Menghapus semua saham dari watchlist
              await saveList(
                  stocksIncluded); // Menyimpan perubahan ke SharedPreferences
              setState(() {}); // Memperbarui state untuk membangun ulang UI
            },
            icon: Icon(Icons.delete,
                color: Colors.red), // Tombol untuk menghapus semua saham
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              key: const ValueKey(
                  "searchBar"), // Key untuk mencari widget TextField
              controller: _controller, // Menggunakan controller untuk TextField
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: TextButton(
                  key: const ValueKey("searchButton"), // Key untuk tombol 'Add'
                  onPressed: () async {
                    String symbol = _controller.text
                        .toUpperCase(); // Mendapatkan simbol saham dari input dan mengonversinya menjadi huruf besar
                    if (!stocksIncluded.contains(symbol)) {
                      // Memeriksa apakah simbol saham sudah ada dalam watchlist
                      try {
                        StockData stock = await StockData.fetchStockData(
                            symbol); // Mengambil data saham dari API
                        if (stock.symbol != "NONE") {
                          // Jika simbol saham valid
                          stocksIncluded.add(
                              symbol); // Menambahkan simbol saham ke watchlist
                          await saveList(
                              stocksIncluded); // Menyimpan perubahan ke SharedPreferences
                          setState(
                              () {}); // Memperbarui state untuk membangun ulang UI
                        }
                      } catch (e) {
                        print(
                            "Error fetching stock data: $e"); // Menangani error saat mengambil data saham
                      }
                    }
                    _controller.clear(); // Mengosongkan input TextField
                    FocusManager.instance.primaryFocus
                        ?.unfocus(); // Menutup keyboard setelah selesai
                  },
                  child: const Text('Add',
                      style:
                          TextStyle(fontSize: 20)), // Label untuk tombol 'Add'
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
                  .map((symbol) => StockData.fetchStockData(
                      symbol)) // Memuat data saham untuk setiap simbol dalam watchlist
                  .toList()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Indikator loading saat data sedang dimuat
                } else if (snapshot.hasData) {
                  List<StockData> data =
                      snapshot.data!; // Mendapatkan data saham yang dimuat
                  return ReorderableListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return StockCard(
                        key: ValueKey(index), // Key untuk kartu saham
                        stock: data[index], // Data saham untuk ditampilkan
                        onDelete: () async {
                          stocksIncluded.removeAt(
                              index); // Menghapus saham dari watchlist
                          await saveList(
                              stocksIncluded); // Menyimpan perubahan ke SharedPreferences
                          setState(
                              () {}); // Memperbarui state untuk membangun ulang UI
                        },
                      );
                    },
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }
                      final String item = stocksIncluded.removeAt(
                          oldIndex); // Menghapus item dari posisi lama
                      stocksIncluded.insert(
                          newIndex, item); // Menyisipkan item pada posisi baru
                      await saveList(
                          stocksIncluded); // Menyimpan perubahan ke SharedPreferences
                      setState(
                          () {}); // Memperbarui state untuk membangun ulang UI
                    },
                  );
                } else {
                  return Center(
                      child: Text(
                          "No data available")); // Pesan jika tidak ada data yang tersedia
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan kartu saham dalam watchlist
class StockCard extends StatelessWidget {
  final StockData stock; // Data saham
  final VoidCallback
      onDelete; // Fungsi panggilan balik untuk menghapus saham dari watchlist

  const StockCard(
      {required Key key, required this.stock, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Margin dari kartu saham
      child: ListTile(
        contentPadding:
            const EdgeInsets.all(10), // Padding konten dalam ListTile
        leading: Icon(Icons.show_chart,
            color: Colors.lightBlueAccent,
            size: 40), // Icon di sebelah kiri ListTile
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Spasi atas antara elemen
            Text("Symbol: ${stock.symbol}", // Menampilkan simbol saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk simbol saham
            Text(
                "Open: \Rp${stock.open.toStringAsFixed(2)}", // Menampilkan harga pembukaan saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk harga saham
            Text(
                "High: \Rp${stock.high.toStringAsFixed(2)}", // Menampilkan harga tertinggi saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk harga saham
            Text(
                "Low: \Rp${stock.low.toStringAsFixed(2)}", // Menampilkan harga terendah saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk harga saham
            Text(
                "Close: \Rp${stock.close.toStringAsFixed(2)}", // Menampilkan harga penutupan saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk harga saham
            Text("Volume: ${stock.volume}", // Menampilkan volume saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk volume saham
            Text(
                "Change: \Rp${stock.change.toStringAsFixed(2)}", // Menampilkan perubahan harga saham
                style: const TextStyle(
                    fontSize: 20)), // Gaya teks untuk harga saham
            Text(
              "Change Percentage: ${stock.changePct}%", // Menampilkan persentase perubahan harga saham
              style: TextStyle(
                color: stock.changePct > 0
                    ? Colors.green
                    : Colors.red, // Warna teks berdasarkan perubahan harga
                fontSize: 20,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete,
              color: Colors.red), // Tombol untuk menghapus saham dari watchlist
          onPressed: onDelete,
        ),
      ),
    );
  }
}
