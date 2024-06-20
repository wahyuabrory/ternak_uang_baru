import 'package:http/http.dart'
    as http; // Import pustaka http untuk melakukan HTTP requests
import 'dart:convert'; // Import pustaka dart:convert untuk mengonversi JSON

class StockData {
  final String symbol; // Simbol saham (misalnya: AAPL, GOOGL)
  final String name; // Nama perusahaan
  final String logo; // URL logo perusahaan
  final String date; // Tanggal data harga saham
  final num open; // Harga pembukaan
  final num high; // Harga tertinggi
  final num low; // Harga terendah
  final num close; // Harga penutupan
  final int volume; // Volume perdagangan
  final num change; // Perubahan harga
  final num changePct; // Persentase perubahan harga

  static const String apiKey =
      "0f247386-e768-5cca-85e8-dee941c4"; // API key untuk akses ke API stock
  static const String apiUrl =
      "https://api.goapi.io/stock/idx/prices"; // URL API untuk mendapatkan data harga saham

  StockData({
    required this.symbol,
    required this.name,
    required this.logo,
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.change,
    required this.changePct,
  });

  // Factory method untuk membuat objek StockData dari JSON
  factory StockData.fromJson(Map<String, dynamic> json) {
    var result =
        json['data']['results'][0]; // Mengambil hasil pertama dari respons JSON
    String logoUrl = result['company']['logo'] ??
        ''; // URL logo perusahaan dari respons JSON
    logoUrl = logoUrl.replaceAll(r'\/', '/'); // Memperbaiki format URL logo

    return StockData(
      symbol: result['symbol'] ?? '', // Mendapatkan simbol saham
      name: result['company']['name'] ?? '', // Mendapatkan nama perusahaan
      logo: result['company']['logo'] ?? '', // Mendapatkan URL logo perusahaan
      date: result['date'] ?? '', // Mendapatkan tanggal data harga saham
      open: result['open'] ?? 0, // Mendapatkan harga pembukaan
      high: result['high'] ?? 0, // Mendapatkan harga tertinggi
      low: result['low'] ?? 0, // Mendapatkan harga terendah
      close: result['close'] ?? 0, // Mendapatkan harga penutupan
      volume: result['volume'] ?? 0, // Mendapatkan volume perdagangan
      change: result['change'] ?? 0, // Mendapatkan perubahan harga
      changePct:
          result['change_pct'] ?? 0.0, // Mendapatkan persentase perubahan harga
    );
  }

  // Metode statis untuk mengambil data harga saham dari API berdasarkan simbol saham
  static Future<StockData> fetchStockData(String symbol) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl?symbols=$symbol&api_key=$apiKey'), // URL lengkap untuk request
      headers: {
        'accept': 'application/json', // Header untuk menerima respons JSON
        'X-API-KEY': apiKey, // Header API key untuk akses ke API
      },
    );

    print(
        'Response status: ${response.statusCode}'); // Mencetak status respons HTTP
    print('Response body: ${response.body}'); // Mencetak isi respons HTTP

    if (response.statusCode == 200) {
      // Jika respons sukses (status code 200)
      return StockData.fromJson(
          json.decode(response.body)); // Mengonversi JSON ke objek StockData
    } else {
      throw Exception(
          'Failed to load stock data'); // Jika gagal, lempar exception
    }
  }
}
