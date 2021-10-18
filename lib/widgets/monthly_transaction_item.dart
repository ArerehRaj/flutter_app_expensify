import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/transactions.dart';

class MonthlyTransactionItem extends StatefulWidget {
  // final TransactionItem transaction;
  final int monthNumber;
  final double totalSpending;

  MonthlyTransactionItem(
    // this.transaction,
    this.monthNumber,
    this.totalSpending,
  );

  @override
  _MonthlyTransactionItemState createState() => _MonthlyTransactionItemState();
}

class _MonthlyTransactionItemState extends State<MonthlyTransactionItem> {
  String getMonthName(int month_number) {
    switch (month_number) {
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              getMonthName(
                int.parse(
                  widget.monthNumber.toString(),
                ),
              ),
              style: const TextStyle(fontSize: 19),
            ),
            subtitle: Text(
              '₹${widget.totalSpending}',
              style: const TextStyle(fontSize: 17),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
