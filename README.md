# chandan_project

A Flutter application for generating and previewing PDF invoices based on selected products. You can add your name and email, select products, and generate and download a PDF invoice.

## Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/chandan_project.git
   cd chandan_project
2. **Get dependencies**
   ```bash
   flutter pub get
3. **Run the app**
    ```bash
    flutter run

## Features

- Product selection with price summary
- User input for name and email
- PDF invoice generation using `pdf` package
- Preview PDF with `flutter_pdfview`
- Save PDF to Downloads folder
- Share PDF

---

## Technologies Used

- **Flutter**
- `pdf`: for creating PDF documents
- `flutter_pdfview`: to preview PDFs
- `share_plus`: for sharing files
- `path_provider`: for accessing the device file system

---

## Folder Structure

    ├── assets/
    │ └── fonts/
    ├── lib/
    │ ├── models/
    │ │ └── product.dart
    │ ├── screens/
    │ │ ├── product_invoice_selection_screen.dart
    │ │ └── data_preview_screen.dart
    │ ├── services/
    │ │ └── pdf_service.dart
    │ └── main.dart


