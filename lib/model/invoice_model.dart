// class Invoice {
//   final String invoiceNumber;
//   final String date;
//   final String duplicate;

//   Invoice({
//     required this.invoiceNumber,
//     required this.date,
//     required this.duplicate,
//   });

//   factory Invoice.fromJson(Map<String, dynamic> json) {
//     final data = json["Extracted_data"];
//     return Invoice(
//       invoiceNumber: data["Invoice_number"] ?? "",
//       date: data["Transaction_date"] ?? "",
//       duplicate: json["Duplicate"] ?? "0",
//     );
//   }
  
// }

// class Supplier {
//   final String name;
//   final List<Invoice> invoices;

//   Supplier({required this.name, required this.invoices});

//   factory Supplier.fromJson(Map<String, dynamic> json) {
//     return Supplier(
//       name: json["Supplier_name"] ?? "",
//       invoices: (json["Invoices"] as List)
//           .map((inv) => Invoice.fromJson(inv))
//           .toList(),
//     );
//   }
// }

class InvoiceItem {
  final String name;
  final String qty;
  final String rate;
  final String memo;

  InvoiceItem({
    required this.name,
    required this.qty,
    required this.rate,
    required this.memo,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      name: json["Item_name"] ?? "",
      qty: json["Qty"] ?? "0",
      rate: json["Rate"] ?? "0",
      memo: json["Memo"] ?? "",
    );
  }
}

class Invoice {
  final String invoiceNumber;
  final String date;
  final String duplicate;
  final String currency;
  final double amount;
  final List<InvoiceItem> items;

  Invoice({
    required this.invoiceNumber,
    required this.date,
    required this.duplicate,
    required this.currency,
    required this.amount,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final data = json["Extracted_data"];
    final itemLines = (data["Item_lines"] as List?) ?? [];

    double totalAmount = 0;
    final parsedItems = itemLines.map((item) {
      final qty = double.tryParse(item["Qty"].toString()) ?? 0;
      final rate = double.tryParse(item["Rate"].toString()) ?? 0;
      totalAmount += qty * rate;
      return InvoiceItem.fromJson(item);
    }).toList();

    return Invoice(
      invoiceNumber: data["Invoice_number"] ?? "",
      date: data["Transaction_date"] ?? "",
      duplicate: json["Duplicate"] ?? "0",
      currency: data["Currency"] ?? "UNKNOWN",
      amount: totalAmount,
      items: parsedItems,
    );
  }

  bool get isDuplicate => duplicate != "0";
}
class Supplier {
  final String name;
  final List<Invoice> invoices;

  Supplier({required this.name, required this.invoices});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      name: json["Supplier_name"] ?? "",
      invoices: (json["Invoices"] as List)
          .map((inv) => Invoice.fromJson(inv))
          .toList(),
    );
  }
}
