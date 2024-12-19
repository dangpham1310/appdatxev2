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
      Uri.parse('https://api.dannycode.site/lsgd'),
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
      backgroundColor: Colors.white,
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
              return Center(child: Text('Không Tìm Thấy Lịch Sử Giao Dịch'));
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

    // Format the amount to 'nghìn VND'
    String formattedAmount =
        '${transaction.type} ${transaction.amount.abs().toStringAsFixed(0)} nghìn VND';

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
          Row(
            children: [
              Icon(icon,
                  color: transaction.type == "+" ? Colors.green : Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  transaction.content, // Ensure full content display
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CupertinoColors.systemGrey,
                  ),
                  softWrap: true, // Allow wrapping
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  transaction.date,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CupertinoColors.systemGrey,
                  ),
                  softWrap: true, // Allow wrapping
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Text(
                  formattedAmount, // Display the formatted amount
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == "+" ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.right, // Align to the right
                  softWrap: true, // Allow wrapping
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Tổng Cộng: ${transaction.total.toStringAsFixed(0)} nghìn VND',
            style: TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.systemGrey,
            ),
            softWrap: true, // Allow wrapping
          ),
          SizedBox(height: 8),
          Text(
            'Mã Số Giao Dịch: ${transaction.id}',
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromARGB(255, 141, 82, 46),
            ),
            softWrap: true, // Allow wrapping
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
  final String content;

  Transaction(
      {required this.id,
      required this.type,
      required this.date,
      required this.amount,
      required this.total,
      required this.content});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '+',
      date: json['date'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      total: json['total']?.toDouble() ?? 0.0,
      content: json['content'] ?? '',
    );
  }
}
