import 'package:ai/chart/supplierinvoicechart.dart';
import 'package:ai/widgets/randomcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';
import '../../controller/dashboard_controller.dart';
import '../../model/invoice_model.dart';
import 'stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- EXISTING STATCARDS ----------------
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final totalInvoices = controller.suppliers.fold<int>(
                        0,
                        (sum, s) => sum + s.invoices.length,
                      );
                      return StatCard(
                        amount: "$totalInvoices",
                        title: "Total Invoices",
                        imagePath: AppAssets.card,
                        backgroundColor: AppColor.dashblue,
                        imageColor: AppColor.dashdarkblue,
                      );
                    }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Obx(() {
                      final totalSuppliers = controller.suppliers.length;
                      return StatCard(
                        amount: "$totalSuppliers",
                        title: "Total Suppliers",
                        imagePath: AppAssets.card,
                        backgroundColor: AppColor.dashgreen,
                        imageColor: AppColor.dashdarkgreen,
                      );
                    }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Obx(() {
                      int duplicateCount = 0;
                      for (var s in controller.suppliers) {
                        duplicateCount += s.invoices
                            .where((inv) => inv.duplicate != "0")
                            .length;
                      }
                      return StatCard(
                        amount: "$duplicateCount",
                        title: "Duplicate Invoices",
                        imagePath: AppAssets.card,
                        backgroundColor: AppColor.dashgrey,
                        imageColor: AppColor.dashdarkgrey,
                      );
                    }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Obx(() {
                      int nonDuplicateCount = 0;
                      for (var s in controller.suppliers) {
                        nonDuplicateCount += s.invoices
                            .where((inv) => inv.duplicate == "0")
                            .length;
                      }
                      return StatCard(
                        amount: "$nonDuplicateCount",
                        title: "Non-Duplicate Invoices",
                        imagePath: AppAssets.card,
                        backgroundColor: AppColor.dashred,
                        imageColor: AppColor.dashdarkred,
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- GETX CHARTS BELOW ----------------
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(child: Text(controller.error.value));
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SupplierInvoiceChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: DuplicateChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InvoiceTimelineChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InvoiceCountByMonthChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TopSuppliersChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InvoiceByCurrencyChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ItemQuantityChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InvoiceAmountBySupplierChart(
                              suppliers: controller.suppliers,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- CHARTS -----------------
final colors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.red,
  Colors.amber,
  Colors.cyan,
  Colors.deepPurple,
  Colors.lime,
];

final chartColors = [
  Color(0xFF4DB6AC),
  Color(0xFFBA68C8),
  Color(0xFFFFD54F),
  Color(0xFF81C784),
  Color(0xFF7986CB),
  Color(0xFFE57373),
  Color(0xFF64B5F6),
  Color(0xFFA1887F),
];

class _ChartData {
  final String label;
  final int value;
  final String? text;
  final String? supplierName;

  _ChartData(this.label, this.value, {this.text, this.supplierName});
}

// class SupplierInvoiceChart extends StatelessWidget {
//   final List<Supplier> suppliers;
//   const SupplierInvoiceChart({super.key, required this.suppliers});

//   @override
//   Widget build(BuildContext context) {
//     final data = suppliers
//         .map((s) => _ChartData(s.name, s.invoices.length, supplierName: s.name))
//         .toList();

//     return Column(
//       children: [
//         SizedBox(height: 5),
//         Text(
//           "Invoices per Supplier",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
//         ),
//         SizedBox(height: 20),
//         SfCartesianChart(
//           primaryXAxis: CategoryAxis(),
//           tooltipBehavior: TooltipBehavior(enable: true),
//           series: [
//             BarSeries<_ChartData, String>(
//               dataSource: data,
//               xValueMapper: (d, _) => d.label,
//               yValueMapper: (d, _) => d.value,
//               pointColorMapper: (_, index) => Color(0xFF345d7d),
//               dataLabelSettings: DataLabelSettings(
//                 isVisible: true,
//                 angle: -90, // vertical text
//                 labelAlignment: ChartDataLabelAlignment.middle,

//                 textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class DuplicateChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const DuplicateChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    int dup = 0, nonDup = 0;
    String customerName = suppliers.isNotEmpty
        ? suppliers.first.name
        : "Unknown";
    for (var s in suppliers) {
      for (var inv in s.invoices) {
        if (inv.duplicate != "0") {
          dup++;
        } else {
          nonDup++;
        }
      }
    }

    final data = [
      _ChartData("Duplicate", dup, text: "$dup", supplierName: customerName),
      _ChartData(
        "Non-Duplicate",
        nonDup,
        text: "$nonDup",
        supplierName: customerName,
      ),
    ];

    return Column(
      children: [
        Text(
          "Duplicate vs Non-Duplicate",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 20),
        SfCircularChart(
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: [
            DoughnutSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => "${d.label}-${d.supplierName}",
              yValueMapper: (d, _) => d.value,

              // pointColorMapper: (_, index) => colors[index % colors.length],
              dataLabelMapper: (d, _) =>
                  '${d.value}', // Only count inside slice
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InvoiceTimelineChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const InvoiceTimelineChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {};
    for (var s in suppliers) {
      for (var inv in s.invoices) {
        if (inv.date.isNotEmpty) {
          counts[inv.date] = (counts[inv.date] ?? 0) + 1;
        }
      }
    }

    final data = counts.entries.map((e) => _ChartData(e.key, e.value)).toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return Column(
      children: [
        Text(
          "Invoices by Transaction Date",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 20),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: [
            LineSeries<_ChartData, String>(
              pointColorMapper: (_, __) => getRandomColor(),
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class InvoiceCountByMonthChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const InvoiceCountByMonthChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> monthly = {};
    for (var s in suppliers) {
      for (var inv in s.invoices) {
        if (inv.date.isNotEmpty) {
          final month = inv.date.substring(0, 7); // YYYY-MM
          monthly[month] = (monthly[month] ?? 0) + 1;
        }
      }
    }

    final data = monthly.entries.map((e) => _ChartData(e.key, e.value)).toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return Column(
      children: [
        Text(
          "Invoices per Month",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 20),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: [
            AreaSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class TopSuppliersChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const TopSuppliersChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final data =
        suppliers.map((s) => _ChartData(s.name, s.invoices.length)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = data.take(5).toList();

    return Column(
      children: [
        Text(
          "Top 5 Suppliers list",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: [
            ColumnSeries<_ChartData, String>(
              dataSource: top5,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (_, index) =>
                  chartColors[index % chartColors.length],
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class InvoiceByCurrencyChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const InvoiceByCurrencyChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {};
    for (var s in suppliers) {
      for (var inv in s.invoices) {
        final currency = inv.currency.isNotEmpty ? inv.currency : "Unknown";
        counts[currency] = (counts[currency] ?? 0) + 1;
      }
    }

    final data = counts.entries.map((e) => _ChartData(e.key, e.value)).toList();

    return Column(
      children: [
        Text(
          "Invoices by Currency",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SfCircularChart(
          legend: Legend(isVisible: true),
          series: [
            DoughnutSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemQuantityChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const ItemQuantityChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> itemCounts = {};
    for (var s in suppliers) {
      for (var inv in s.invoices) {
        for (var item in inv.items) {
          final qty = double.tryParse(item.qty) ?? 0;
          itemCounts[item.name] = (itemCounts[item.name] ?? 0) + qty;
        }
      }
    }

    final data =
        itemCounts.entries
            .map((e) => _ChartData(e.key, e.value.toInt()))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final top10 = data.take(10).toList();

    return Column(
      children: [
        Text(
          "Top Items by Quantity",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: [
            BarSeries<_ChartData, String>(
              dataSource: top10,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}

class InvoiceAmountBySupplierChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const InvoiceAmountBySupplierChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> totals = {};

    for (var s in suppliers) {
      double supplierTotal = 0;
      for (var inv in s.invoices) {
        supplierTotal += inv.amount;
      }
      totals[s.name.isNotEmpty ? s.name : "Unknown Supplier"] =
          (totals[s.name] ?? 0) + supplierTotal;
    }

    final data = totals.entries
        .map((e) => _ChartData(e.key, e.value.toInt()))
        .toList();

    return Column(
      children: [
        Text(
          "Invoice Amount by Supplier",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: [
            ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.label,
              yValueMapper: (d, _) => d.value,

              pointColorMapper: (_, index) => colors[index % colors.length],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }
}
