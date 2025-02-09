import 'dart:io';

import 'package:csv/csv.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static Future<void> exportToCSV(List<ExpenseModel> expenses) async {
    try {
      List<List<dynamic>> rows = [
        ['Title', 'Amount', 'Category', 'Date']
      ];

      debugPrint("rows = ${rows.length}");
      for (var expense in expenses) {
        rows.add([
          expense.title,
          expense.amount,
          expense.category,
          expense.date,
        ]);
      }

      String csvData = ListToCsvConverter().convert(rows);
      debugPrint("csvData = $csvData");
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/expenses.csv');

      debugPrint('File saved to: $file');
      await file.writeAsString(csvData);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> exportToPDF(List<ExpenseModel> expenses) async {
    final pdf = pw.Document();

    // Calculate the total amount of all expenses
    final totalAmount =
        expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Expense Report',
                  style: pw.TextStyle(fontSize: 24),
                ),
              ),
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Title', 'Amount', 'Category'],
                // Removed 'Time'
                data: expenses
                    .map((e) => [
                          DateFormat('yyyy-MM-dd').format(e.date),
                          e.title,
                          '\$${e.amount.toStringAsFixed(2)}',
                          e.category.name,
                        ])
                    .toList(),
                cellStyle: pw.TextStyle(fontSize: 12),
                headerStyle: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blueAccent,
                ),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerLeft,
                },
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total Expenses: \$${totalAmount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
