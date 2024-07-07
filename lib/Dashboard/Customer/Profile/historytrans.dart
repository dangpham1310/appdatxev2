import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryTransactionPage extends StatelessWidget {
  List<Transaction> transactionData = [
    Transaction(
      title: 'Nạp Tiền',
      date: '20 Tháng Sáu, 2024',
      amount: 125.75,
    ),
    Transaction(
      title: 'Rút Tiền',
      date: '18 Tháng Sáu, 2024',
      amount: -50.00,
    ),
    Transaction(
      title: 'Tiền Hoa Hồng',
      date: '15 Tháng Sáu, 2024',
      amount: 200.00,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text("Lịch Sử Giao Dịch", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF40B59F),
        leading: GestureDetector(
          onTap: () {
            // Handle the back button tap here
            Navigator.of(context).pop();
          },
          child: Container(
            child: Icon(
              CupertinoIcons.back,
              color: Colors.white, // Set the color of the back button
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          itemCount: transactionData.length,
          itemBuilder: (context, index) {
            return TransactionListItem(
              transaction: transactionData[index],
            );
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
    Color boxColor = (transaction.title == 'Nạp Tiền' ||
            transaction.title == 'Tiền Hoa Hồng')
        ? Color(0xFF40B59F).withOpacity(0.3)
        : Colors.red.withOpacity(0.3);

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
          Text(
            transaction.title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.date,
                style: TextStyle(
                  fontSize: 14.0,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final String title;
  final String date;
  final double amount;

  Transaction({required this.title, required this.date, required this.amount});
}
