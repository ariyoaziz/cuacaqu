import 'package:cuacaqu/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cuacaqu/main.dart'; // Pastikan file ini sudah benar diimport

void main() {
  testWidgets('Weather location test', (WidgetTester tester) async {
    // Membuat aplikasi dan merender halaman Home.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(), // Gantilah dengan widget yang sesuai
    ));

    // Periksa apakah ada teks yang menunjukkan lokasi cuaca atau informasi awal.
    expect(find.text('Current Location'),
        findsOneWidget); // Menyesuaikan dengan teks yang ada di aplikasi Anda
    expect(find.text('Loading...'),
        findsNothing); // Pastikan tidak ada loading yang muncul.

    // Anda dapat memodifikasi tes ini dengan mencari elemen lain yang relevan seperti tombol atau cuaca.
    // Misalnya, memeriksa cuaca setelah memuat data.
  });
}
