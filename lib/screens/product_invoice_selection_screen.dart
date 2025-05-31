import 'package:chandan_project/screens/data_preview_screen.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/pdf_service.dart';

class ProductInvoicetSelectionScreen extends StatefulWidget {
  const ProductInvoicetSelectionScreen({super.key});

  @override
  State<ProductInvoicetSelectionScreen> createState() =>
      _ProductInvoiceSelectionScreenState();
}

class _ProductInvoiceSelectionScreenState
    extends State<ProductInvoicetSelectionScreen> {
  // Sample product list
  final List<Product> products = [
    Product(name: "Product A", price: 100),
    Product(name: "Product B", price: 200),
    Product(name: "Product C", price: 150),
    Product(name: "Product D", price: 250),
    Product(name: "Product E", price: 300),
  ];

  // To keep track of selected products
  final Map<Product, bool> selectedProducts = {};

  // Controllers for user input (name and email)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize all products as unselected
    for (var product in products) {
      selectedProducts[product] = false;
    }
  }

  /// Generates a PDF invoice based on selected products and user info
  void generatePDF() async {
    // Get only the selected products
    final selected = selectedProducts.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final name = nameController.text.trim();
    final email = emailController.text.trim();

    // Check if required fields are filled
    if (selected.isEmpty || name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select products and fill name/email")),
      );
      return;
    }

    // Generate the PDF using PdfService
    final file = await PdfService.generateInvoice(name, email, selected);

    // If widget was removed from the widget tree before PDF generation completed
    if (!mounted) return;

    // Navigate to preview screen with generated PDF file
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DataPreviewScreen(file.path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Selection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 13, 13, 201),
        iconTheme: const IconThemeData(color: Colors.white), // white back icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // List of products with checkboxes
            ...products.map(
              (product) => CheckboxListTile(
                title: Text("${product.name} ₹${product.price}"),
                value: selectedProducts[product],
                onChanged: (val) => setState(() {
                  selectedProducts[product] = val ?? false;
                }),
              ),
            ),

            // Text field to input name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            // Text field to input email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            // Generate PDF button
            ElevatedButton(
              onPressed: generatePDF,
              child: const Text("Generate PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
