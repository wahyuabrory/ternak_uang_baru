import 'package:http/http.dart' as http;
import 'dart:convert';

class StockData {
  final String symbol;
  final String name;
  final String logo;
  final String date;
  final num open;
  final num high;
  final num low;
  final num close;
  final int volume;
  final num change;
  final num changePct;

  static const String apiKey = "0f247386-e768-5cca-85e8-dee941c4";
  static const String apiUrl = "https://api.goapi.io/stock/idx/prices";

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

  factory StockData.fromJson(Map<String, dynamic> json) {
    var result = json['data']['results'][0];
    String logoUrl = result['company']['logo'] ?? '';
    logoUrl = logoUrl.replaceAll(r'\/', '/');

    return StockData(
      symbol: result['symbol'] ?? '',
      name: result['company']['name'] ?? '',
      logo: result['company']['logo'] ?? '',
      date: result['date'] ?? '',
      open: result['open'] ?? 0,
      high: result['high'] ?? 0,
      low: result['low'] ?? 0,
      close: result['close'] ?? 0,
      volume: result['volume'] ?? 0,
      change: result['change'] ?? 0,
      changePct: result['change_pct'] ?? 0.0,
    );
  }

  static Future<StockData> fetchStockData(String symbol) async {
    final response = await http.get(
      Uri.parse('$apiUrl?symbols=$symbol&api_key=$apiKey'),
      headers: {
        'accept': 'application/json',
        'X-API-KEY': apiKey,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return StockData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load stock data');
    }
  }
}
