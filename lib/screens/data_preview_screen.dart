import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DataPreviewScreen extends StatelessWidget {
  final String path;

  const DataPreviewScreen(this.path, {super.key});

  /// Method to copy the PDF file to the Downloads folder
  void _downloadMyPDF(BuildContext context) async {
    try {
      // Define the Downloads directory and file name
      final directory = Directory('/storage/emulated/0/Download');
      final fileName = "Invoice__${DateTime.now().millisecondsSinceEpoch}.pdf";
      final newPath = "${directory.path}/$fileName";

      // Copy the file to Downloads
      final newFile = await File(path).copy(newPath);

      // Show confirmation SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved: ${newFile.path}")),
      );
    } catch (e) {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
    }
  }

  /// Method to share the PDF using share_plus
  void _shareMyPdf() async {
    final xfile = XFile(path);
    await Share.shareXFiles([xfile], text: 'Here is your invoice.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF Preview",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 13, 13, 201),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // PDF viewer
          Expanded(child: PDFView(filePath: path)),

          // Buttons for Download and Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _downloadMyPDF(context),
                child: const Text("Download"),
              ),
              ElevatedButton(
                onPressed: _shareMyPdf,
                child: const Text("Share"),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
