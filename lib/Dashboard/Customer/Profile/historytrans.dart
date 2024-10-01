import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryTransactionPage extends StatefulWidget {
  @override
  _HistoryTransactionPageState createState() => _HistoryTransactionPageState();
}

class _HistoryTransactionPageState extends State<HistoryTransactionPage> {
  late Future<List<Transaction>> transactionData;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      setState(() {
        transactionData = fetchTransactions(accessToken);
      });
    } else {
      setState(() {
        transactionData = Future.error('No access token found');
      });
    }
  }

  Future<List<Transaction>> fetchTransactions(String accessToken) async {
    final response = await http.post(
      Uri.parse('https://api.dantay.vn/lsgd'),
      body: {'accessToken': accessToken},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Lịch Sử Giao Dịch",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<Transaction>>(
          future: transactionData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không Tìm Thấy Lịch Sử Giao Dịch '));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return TransactionListItem(
                      transaction: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color boxColor = transaction.type == "+"
        ? Color(0xFF40B59F).withOpacity(0.2)
        : Colors.red.withOpacity(0.2);

    IconData icon = transaction.type == "+"
        ? CupertinoIcons.arrow_down
        : CupertinoIcons.arrow_up;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey3.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Transaction ID without truncating it
          Row(
            children: [
              Icon(icon,
                  color: transaction.type == "+" ? Colors.green : Colors.red),
              SizedBox(width: 8),
              // Ensure the Transaction ID is always fully visible
              Text(
                'Mã số giao dịch: ${transaction.id}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Row for Date and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use Flexible for the date
              Flexible(
                flex: 2,
                child: Text(
                  'Thời Gian: ${transaction.date}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CupertinoColors.systemGrey,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
              SizedBox(width: 10),
              // Use Flexible for the amount
              Flexible(
                flex: 1,
                child: Text(
                  '${transaction.type} \$${transaction.amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == "+" ? Colors.green : Colors.red,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Display total amount at the bottom
          Text(
            'Tổng Cộng: \$${transaction.total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final int id;
  final String type;
  final String date;
  final double amount;
  final double total;

  Transaction(
      {required this.id,
      required this.type,
      required this.date,
      required this.amount,
      required this.total});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '+',
      date: json['date'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      total: json['total']?.toDouble() ?? 0.0,
    );
  }
}
