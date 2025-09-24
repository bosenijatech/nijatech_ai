

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';
import '../../controller/dashboard_controller.dart';
import '../../model/invoice_model.dart';
import 'stat_card.dart';


class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

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
                children: const [
                  Expanded(
                    child: StatCard(
                      amount: "\$15,000",
                      title: "Total Revenue",
                      imagePath: AppAssets.card,
                      backgroundColor: AppColor.dashblue,
                      imageColor: AppColor.dashdarkblue,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: StatCard(
                      amount: "\$12,500",
                      title: "Total Orders",
                      imagePath: AppAssets.cart,
                      backgroundColor: AppColor.dashgreen,
                      imageColor: AppColor.dashdarkgreen,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: StatCard(
                      amount: "\$8,750",
                      title: "Net Profit",
                      imagePath: AppAssets.van,
                      backgroundColor: AppColor.dashgrey,
                      imageColor: AppColor.dashdarkgrey,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: StatCard(
                      amount: "\$5,000",
                      title: "Expenses",
                      imagePath: AppAssets.eye,
                      backgroundColor: AppColor.dashred,
                      imageColor: AppColor.dashdarkred,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),

              // ---------------- GETX CHARTS BELOW ----------------
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.value.isNotEmpty) {
                  return Center(child: Text(controller.error.value));
                }

                return
            
                 Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                         
                          child: SupplierInvoiceChart(suppliers: controller.suppliers),
                        ),
                           const SizedBox(width: 20),
                    Expanded(
                
                      child: DuplicateChart(suppliers: controller.suppliers),
                    ),
                      ],
                    ),
                 
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                      
                          child: InvoiceTimelineChart(suppliers: controller.suppliers),
                        ),
                         const SizedBox(width: 20),
                    Expanded(
                   
                      child: InvoiceCountByMonthChart(suppliers: controller.suppliers),
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

class _ChartData {
  final String label;
  final int value;
  _ChartData(this.label, this.value);
}

class SupplierInvoiceChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const SupplierInvoiceChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final data = suppliers.map((s) => _ChartData(s.name, s.invoices.length)).toList();

    return Column(
      children: [
        Text("Invoices per Supplier",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
        SizedBox(height: 20,),
        SfCartesianChart(
         
          
          primaryXAxis: CategoryAxis(),
          
          series: [
            ColumnSeries<_ChartData, String>(
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

class DuplicateChart extends StatelessWidget {
  final List<Supplier> suppliers;
  const DuplicateChart({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    int dup = 0, nonDup = 0;
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
      _ChartData("Duplicate", dup),
      _ChartData("Non-Duplicate", nonDup),
    ];

    return Column(
      children: [
         Text("Duplicate vs Non-Duplicate",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            SizedBox(height: 20,),
        SfCircularChart(
      
          legend: Legend(isVisible: true),
          series: [
            PieSeries<_ChartData, String>(
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
          Text("Invoices by Transaction Date",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            SizedBox(height: 20,),
        SfCartesianChart(

          primaryXAxis: CategoryAxis(),
          series: [
            LineSeries<_ChartData, String>(
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
         Text("Invoices per Month",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
            SizedBox(height: 20,),
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

