// stock_data.dart

import 'package:flutter/material.dart';
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

    if (response.statusCode == 200) {
      return StockData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load stock data');
    }
  }
}

class StockDisplay extends StatelessWidget {
  final StockData d;

  const StockDisplay({required this.d, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = d.name;
    String logoUrl = d.logo;
    String date = d.date;
    String open = "Rp.${d.open.toStringAsFixed(2)}";
    String high = "Rp.${d.high.toStringAsFixed(2)}";
    String low = "Rp.${d.low.toStringAsFixed(2)}";
    String close = "Rp.${d.close.toStringAsFixed(2)}";
    String volume = d.volume.toString();
    String change = "Rp.${d.change.toStringAsFixed(2)}";
    String changePct = "${d.changePct.toStringAsFixed(2)}%";

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  logoUrl,
                  width: 50,
                  height: 50,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("Symbol: ${d.symbol}", style: const TextStyle(fontSize: 20)),
          Text("Date: $date", style: const TextStyle(fontSize: 20)),
          Text("Open: $open", style: const TextStyle(fontSize: 20)),
          Text("High: $high", style: const TextStyle(fontSize: 20)),
          Text("Low: $low", style: const TextStyle(fontSize: 20)),
          Text("Close: $close", style: const TextStyle(fontSize: 20)),
          Text("Volume: $volume", style: const TextStyle(fontSize: 20)),
          Text("Change: $change", style: const TextStyle(fontSize: 20)),
          Text(
            "Change Percentage: $changePct",
            style: TextStyle(
              color: d.changePct > 0 ? Colors.green : Colors.red,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
