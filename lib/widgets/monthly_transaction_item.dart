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
