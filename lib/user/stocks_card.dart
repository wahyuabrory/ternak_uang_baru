import 'package:flutter/material.dart';
import 'StockData.dart';

class StockCard extends StatelessWidget {
  final StockData stock;

  const StockCard({required this.stock, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    stock.logo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
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
                    stock.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Symbol: ${stock.symbol}",
                style: const TextStyle(fontSize: 18)),
            Text("Open: Rp.${stock.open}",
                style: const TextStyle(fontSize: 18)),
            Text("High: Rp.${stock.high}",
                style: const TextStyle(fontSize: 18)),
            Text("Low: Rp.${stock.low}", style: const TextStyle(fontSize: 18)),
            Text("Close: Rp.${stock.close}",
                style: const TextStyle(fontSize: 18)),
            Text("Volume: ${stock.volume}",
                style: const TextStyle(fontSize: 18)),
            Text("Change: Rp.${stock.change}",
                style: const TextStyle(fontSize: 18)),
            Text(
              "Change Percentage: ${stock.changePct}%",
              style: TextStyle(
                color: stock.changePct > 0 ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
