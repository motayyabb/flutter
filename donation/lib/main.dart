import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welfare Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

// Model for transactions (donations and expenses)
class Transaction {
  final int? id;
  final String type;
  final String description;
  final int amount;
  final String date;
  final String month;

  Transaction({this.id, required this.type, required this.description, required this.amount, required this.date, required this.month});

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type, 'description': description, 'amount': amount, 'date': date, 'month': month};
  }
}

// Database helper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'transactions.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, type TEXT, description TEXT, amount INTEGER, date TEXT, month TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Transaction>> getTransactionsByMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', where: 'month = ?', whereArgs: [month]);
    return List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        type: maps[i]['type'],
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        month: maps[i]['month'],
      );
    });
  }

  Future<int> getTotalAmountForMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE month = ?', [month]);
    return result.first['total'] ?? 0;
  }
}

// Home screen with enhanced UI design
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
  int _totalAmount = 0;

  // Add donation or expense for the current month
  Future<void> _addTransaction(String type) async {
    final transaction = Transaction(
      type: type,
      description: _descController.text,
      amount: int.parse(_amountController.text),
      date: DateTime.now().toIso8601String(),
      month: _currentMonth,
    );
    await dbHelper.insertTransaction(transaction);
    _descController.clear();
    _amountController.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type Added Successfully')));
    _updateTotalAmount();
  }

  // Update the total amount for the current month
  Future<void> _updateTotalAmount() async {
    final total = await dbHelper.getTotalAmountForMonth(_currentMonth);
    setState(() {
      _totalAmount = total;
    });
  }

  // Show month-wise donations
  void _showMonthWiseDonations() async {
    final transactions = await dbHelper.getTransactionsByMonth(_currentMonth);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transactions for $_currentMonth'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: transactions.map((txn) {
            return Text('${txn.description} - \$${txn.amount}');
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Generate PDF report for the current month
  Future<void> _generatePdfReport() async {
    final pdf = pw.Document();
    final donations = await dbHelper.getTransactionsByMonth(_currentMonth);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Monthly Report ($_currentMonth)', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Donations', style: pw.TextStyle(fontSize: 18)),
              pw.ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  return pw.Text('${donations[index].description} - \$${donations[index].amount}');
                },
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/report_$_currentMonth.pdf');
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF Report Saved at ${file.path}')));
  }

  @override
  void initState() {
    super.initState();
    _updateTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welfare Tracker'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Report',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break; // Stay on home
            case 1:
              _showMonthWiseDonations(); // Show month-wise donations
              break;
            case 2:
              _generatePdfReport(); // Generate PDF report
              break;
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Total Donations for $_currentMonth: \$$_totalAmount', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _addTransaction("donation"),
                  child: Text('Add Donation'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () => _addTransaction("expense"),
                  child: Text('Add Expense'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
