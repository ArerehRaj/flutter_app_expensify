import 'package:expensify_app/screens/monthly_transactions_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/transactions.dart';

class MonthlyTransactionItem extends StatefulWidget {
  // final TransactionItem transaction;
  final int monthNumber;
  final double totalSpending;
  final List monthlyTransactions;

  MonthlyTransactionItem(
    // this.transaction,
    this.monthNumber,
    this.totalSpending,
    this.monthlyTransactions,
  );

  @override
  _MonthlyTransactionItemState createState() => _MonthlyTransactionItemState();
}

class _MonthlyTransactionItemState extends State<MonthlyTransactionItem> {
  String getMonthName(int month_number) {
    switch (month_number) {
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
    }

    return '';
  }

  var _isExpanded = false;

  void getPopUp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'View In Detail',
        ),
        content: const Text(
            'Do you want to view your monthly transactions in detail?'),
        actions: [
          // if the user clicks yes then pop the alert box
          // and return true hence deleted
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // got to edit page
              Navigator.of(context).pushNamed(
                  MonthlyTransactionDetailScreen.routeName,
                  arguments: {
                    'transactions': widget.monthlyTransactions,
                    'month': getMonthName(
                      int.parse(
                        widget.monthNumber.toString(),
                      ),
                    )
                  });
            },
            child: const Text('Yes'),
          ),
          // if the user clicks no then pop the alert box
          // and return false hence not deleted
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.monthlyTransactions.length * 25.0 + 110, 200)
          : 95,
      child: Card(
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
              onLongPress: () {
                getPopUp();
              },
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            if (_isExpanded)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  height: _isExpanded
                      ? min(widget.monthlyTransactions.length * 25.0 + 30, 130)
                      : 0,
                  child: ListView(
                    children: widget.monthlyTransactions
                        .map((trx) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  trx.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${trx.amount.toString()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(trx.date),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
