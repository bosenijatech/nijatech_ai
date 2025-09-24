class Invoice {
  final String invoiceNumber;
  final String date;
  final String duplicate;

  Invoice({
    required this.invoiceNumber,
    required this.date,
    required this.duplicate,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final data = json["Extracted_data"];
    return Invoice(
      invoiceNumber: data["Invoice_number"] ?? "",
      date: data["Transaction_date"] ?? "",
      duplicate: json["Duplicate"] ?? "0",
    );
  }
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
