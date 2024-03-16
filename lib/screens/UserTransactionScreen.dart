import 'dart:io';
import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../controllers/UserTransactionController.dart';
import '../helpers/colors.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/UserTransactionModel.dart';

class UserTransactionScreen extends StatefulWidget {
  final int? userId;

  const UserTransactionScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<UserTransactionScreen> createState() => _UserTransactionScreenState();
}

class _UserTransactionScreenState extends State<UserTransactionScreen> {
  UserTransController userTrans = Get.put(UserTransController());
  List<UserTransaction> transactions = []; // Store fetched transactions
  var isLoading = true; // Track loading state

  final pdf = PdfDocument(); // Create a PDF document

  @override
  void initState() {
    super.initState();
    getTransData();
  }

  Future<void> getTransData() async {
    try {
      transactions = (await userTrans.fetchUserTransaction(widget.userId!))!;
      if (transactions == null) {
        print("No transactions found.");  // Handle null case
      }
    } catch (error) {
      print("Error fetching transactions: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveTransactionsToPdf(List<UserTransaction> transactions) async {
    // Create PDF document
    final pdf = pw.Document();

    // Define table headers
    final headers = ['Date', 'Amount', 'Detail'];

    // Define table rows
    final List<List<String>> rows = transactions.map((transaction) {
      return [
        DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.userTransDate)),
        transaction.userTransAmount.toString(),
        transaction.userTransDetail,
      ];
    }).toList();

    // Create PDF table
    final table = pw.Table.fromTextArray(
      headers: headers,
      data: rows,
      cellAlignment: pw.Alignment.center,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
    );

    // Add table to PDF document
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Center(child: pw.Text('Transactions Details', style: pw.TextStyle(fontSize: 20))),
            pw.SizedBox(height: 20),
            table,
          ];
        },
      ),
    );

    // Get directory for saving PDF
    final filePath = '/storage/emulated/0/Download/Cust${widget.userId}TransactionDetail.pdf';

    // Write PDF to file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (transactions.isNotEmpty) {
      try {
        Get.snackbar("Success", "PDF Saved Successfully\n\nCLICK HERE TO VIEW",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          onTap: (snack) => OpenFilex.open(filePath),
        );
      } catch (e) {
        Get.snackbar("Failed", "Failed to save transactions as PDF",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Transaction Details", style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: SafeArea(
        child: isLoading?customLoading(100):SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(height: 10,),
              DataTable(
                dataTextStyle: primaryStyle(context, pallete4, 3),
                headingTextStyle: primaryStyleBold(context, pallete0, 3.5),
                headingRowColor: MaterialStateProperty.all(pallete4),
                dataRowColor: MaterialStateProperty.all(pallete1),
                border: TableBorder.all(
                  color: Colors.grey, // Set border color
                  width: 1, // Set border width
                ),
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Detail')),
                ],
                rows: transactions.map((transaction) => DataRow(
                  cells: [
                    // Extract and format the date
                    DataCell(Text(
                      DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.userTransDate)),
                    )),
                    DataCell(Text(transaction.userTransAmount.toString()+"/-")),
                    DataCell(Text(transaction.userTransDetail, overflow: TextOverflow.fade)),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: getHeight(context, 0.06),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: pallete4
          ),
          child: transactions.isEmpty?null:TextButton(
              onPressed: () async {
                await saveTransactionsToPdf(transactions);
              },
              child: Text("Save as PDF", style: primaryStyleBold(context, pallete1, 4),)
          ),
        ),
      ),
    );
  }
}
