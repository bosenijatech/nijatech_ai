import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ai/model/invoice_model.dart'; // your models

class SupplierInvoiceChart extends StatefulWidget {
  final List<Supplier> suppliers;
  const SupplierInvoiceChart({super.key, required this.suppliers});

  @override
  State<SupplierInvoiceChart> createState() => _SupplierInvoiceChartState();
}

class _SupplierInvoiceChartState extends State<SupplierInvoiceChart> {
  Supplier? selectedSupplier; // dropdown choice
  Supplier? expandedSupplier; // chart tap choice

  // 🔹 Merge duplicate items across invoices
  List<InvoiceItem> _mergeItems(List<InvoiceItem> items) {
    final Map<String, InvoiceItem> grouped = {};

    for (final item in items) {
      final key = item.name; // merge by name; change to code+name if available
      final int qty = int.tryParse(item.qty) ?? 0;
      final double rate = double.tryParse(item.rate) ?? 0.0;

      if (grouped.containsKey(key)) {
        final existing = grouped[key]!;

        final int existingQty = int.tryParse(existing.qty) ?? 0;

        grouped[key] = InvoiceItem(
          name: existing.name,
          qty: (existingQty + qty).toString(),
          rate: existing.rate,
          memo: existing.memo,
        );
      } else {
        grouped[key] = InvoiceItem(
          name: item.name,
          qty: item.qty,
          rate: item.rate,
          memo: item.memo,
        );
      }
    }

    return grouped.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueSuppliers = {
      for (var s in widget.suppliers) s.name: s,
    }.values.toList();

    final data = uniqueSuppliers
        .map((s) => _ChartData(s.name, s.invoices.length))
        .toList();

    final Supplier? activeSupplier = selectedSupplier ?? expandedSupplier;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Invoices per Supplier", style: TextStyle(fontSize: 20)),
            // Container(
            //   padding: const EdgeInsets.all(3),
            //   width: 250,
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<Supplier>(
            //       hint: const Text(
            //         maxLines: 1,
            //         "Select Supplier",
            //         style: TextStyle(overflow: TextOverflow.ellipsis),
            //       ),
            //       value: selectedSupplier,
            //       isExpanded: true,
            //       onChanged: (value) {
            //         setState(() {
            //           selectedSupplier = value;
            //           expandedSupplier = null;
            //         });
            //       },
            //       items: uniqueSuppliers.map((s) {
            //         return DropdownMenuItem(value: s, child: Text(s.name));
            //       }).toList(),
            //     ),
            //   ),
            // ),
          ],
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          onDataLabelTapped: (DataLabelTapDetails details) {
            final index = details.pointIndex;
            if (index < uniqueSuppliers.length) {
              setState(() {
                expandedSupplier = uniqueSuppliers[index];
                selectedSupplier = null;
              });
            }
          },
          series: [
            BarSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (_, __) => const Color(0xFF345d7d),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                angle: -90,
                labelAlignment: ChartDataLabelAlignment.middle,
                textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        if (activeSupplier != null)
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Items for ${activeSupplier.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Merge items across all invoices
                  ..._mergeItems(
                    activeSupplier.invoices.expand((inv) => inv.items).toList(),
                  ).map((item) {
                    final int qty = int.tryParse(item.qty) ?? 0;
                    final double rate = double.tryParse(item.rate) ?? 0.0;
                    final double total = qty * rate;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "Qty: $qty",
                            style: const TextStyle(fontSize: 13),
                          ),
                          SizedBox(width: 30),
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// ---------------- Helper ----------------

class _ChartData {
  final String label;
  final int value;
  _ChartData(this.label, this.value);
}
