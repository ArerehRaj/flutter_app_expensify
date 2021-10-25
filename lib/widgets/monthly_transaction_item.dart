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
          // then the user will be redirected to a new screen
          // showing the details of that months transaction
          FlatButton(
            onPressed: () {
              // first popping the alert box
              Navigator.of(ctx).pop();
              // redirecting the user and also passing the
              // arguments to show on the next screen
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
          // then the alert box will disappear
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
    // animated container to show the slide down and slide up effect
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.monthlyTransactions.length * 25.0 + 110, 200)
          : 95,
      // card to show the month name and total spending of that month
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              // displaying the month name
              title: Text(
                getMonthName(
                  int.parse(
                    widget.monthNumber.toString(),
                  ),
                ),
                style: const TextStyle(fontSize: 19),
              ),
              // displaying the total spending of that month
              subtitle: Text(
                '₹${widget.totalSpending}',
                style: const TextStyle(fontSize: 17),
              ),
              // setting a long press to show the alert box
              onLongPress: () {
                getPopUp();
              },
              // icon to expand
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
            // if expanded then show the transactions of that month
            if (_isExpanded)
              Expanded(
                // animated container
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
                                // title of that transaction
                                Text(
                                  trx.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                // amount of that transaction
                                Text(
                                  '₹${trx.amount.toString()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                // date of that transaction
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
