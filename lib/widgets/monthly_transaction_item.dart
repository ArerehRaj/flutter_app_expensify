import 'package:flutter/material.dart';

import '../providers/transactions.dart';

class MonthlyTransactionItem extends StatefulWidget {
  final TransactionItem transaction;
  final double totalSpending;

  MonthlyTransactionItem(
    this.transaction,
    this.totalSpending,
  );

  @override
  _MonthlyTransactionItemState createState() => _MonthlyTransactionItemState();
}

class _MonthlyTransactionItemState extends State<MonthlyTransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
