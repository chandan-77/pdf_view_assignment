import 'dart:io';
import 'package:flutter/services.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:pdf/widgets.dart' as pw; 
import '../models/product.dart';

class PdfService {
  /// Generates a PDF invoice with user's name, email, and selected product list.
  static Future<File> generateInvoice(
      String name, String email, List<Product> products) async {
    
    // Create a new PDF document
    final pdf = pw.Document();

    // Load a custom font from assets for consistent styling
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-regular.ttf'));

    // Calculate total price of selected products
    int total = products.fold(0, (sum, p) => sum + p.price);

    // Add a page to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Title
              pw.Text("Invoice", style: pw.TextStyle(fontSize: 24, font: font)),

              pw.SizedBox(height: 20),

              // Customer details
              pw.Text("Name: $name", style: pw.TextStyle(font: font)),
              pw.Text("Email: $email", style: pw.TextStyle(font: font)),

              pw.SizedBox(height: 20),

              // Product table with headers and data
              pw.Table.fromTextArray(
                headers: ['Product', 'Price'],
                data: products.map((p) => [p.name, '₹${p.price}']).toList(),
                cellStyle: pw.TextStyle(font: font),
                headerStyle: pw.TextStyle(
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Divider(),

              // Total amount
              pw.Text("Total: ₹$total", style: pw.TextStyle(fontSize: 18, font: font)),
            ],
          );
        },
      ),
    );

    // Get temporary directory path (e.g., /data/user/0/.../cache)
    final output = await getTemporaryDirectory();

    // Define the file path for the invoice PDF
    final file = File("${output.path}/invoice.pdf");

    // Write the PDF data to the file
    await file.writeAsBytes(await pdf.save());

    // Return the generated file
    return file;
  }
}
