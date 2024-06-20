import 'package:flutter/material.dart';
import 'StockData.dart'; // Import file StockData.dart yang berisi definisi StockData

class StockCard extends StatelessWidget {
  final StockData stock; // Variabel final stock bertipe StockData

  const StockCard({required this.stock, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10), // Margin card sebesar 10
      elevation: 5, // Elevasi card
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10)), // Bentuk card dengan border radius 10
      child: Padding(
        padding: EdgeInsets.all(15), // Padding di dalam card sebesar 15
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Penataan kolom secara horizontal di mulai dari sisi kiri
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8.0), // Border radius untuk gambar
                  child: Image.network(
                    stock.logo, // URL logo dari data saham
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null)
                        return child; // Jika sudah selesai loading, tampilkan gambar
                      return Center(
                        child:
                            CircularProgressIndicator(), // Jika masih dalam proses loading, tampilkan indikator loading
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons
                          .error); // Jika terjadi error saat memuat gambar, tampilkan icon error
                    },
                  ),
                ),
                const SizedBox(width: 10), // Spasi horizontal sebesar 10
                Expanded(
                  child: Text(
                    stock.name, // Nama perusahaan dari data saham
                    style: const TextStyle(
                      fontWeight: FontWeight.w700, // Bobot teks tebal
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Spasi vertikal sebesar 10
            Text(
                "Symbol: ${stock.symbol}", // Text dengan informasi simbol saham
                style: const TextStyle(fontSize: 18)),
            Text(
                "Open: Rp.${stock.open}", // Text dengan informasi harga pembukaan saham
                style: const TextStyle(fontSize: 18)),
            Text(
                "High: Rp.${stock.high}", // Text dengan informasi harga tertinggi saham
                style: const TextStyle(fontSize: 18)),
            Text("Low: Rp.${stock.low}",
                style: const TextStyle(
                    fontSize:
                        18)), // Text dengan informasi harga terendah saham
            Text(
                "Close: Rp.${stock.close}", // Text dengan informasi harga penutupan saham
                style: const TextStyle(fontSize: 18)),
            Text(
                "Volume: ${stock.volume}", // Text dengan informasi volume perdagangan saham
                style: const TextStyle(fontSize: 18)),
            Text(
                "Change: Rp.${stock.change}", // Text dengan informasi perubahan harga saham
                style: const TextStyle(fontSize: 18)),
            Text(
              "Change Percentage: ${stock.changePct}%", // Text dengan informasi persentase perubahan harga saham
              style: TextStyle(
                color: stock.changePct > 0
                    ? Colors.green
                    : Colors
                        .red, // Warna teks berdasarkan perubahan harga positif atau negatif
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
