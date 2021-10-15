import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../widgets/no_transactions.dart';

class MonthlyTransactions extends StatefulWidget {
  const MonthlyTransactions({Key? key}) : super(key: key);

  @override
  State<MonthlyTransactions> createState() => _MonthlyTransactionsState();
}

class _MonthlyTransactionsState extends State<MonthlyTransactions> {
  @override
  Widget build(BuildContext context) {
    final monthlyTransactionData = Provider.of<Transactions>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        monthlyTransactionData.getMonthlyTransactions.isEmpty
            ? const NoTransactions()
            : const Center(
                child: Text('Monthly Transactions'),
              ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.add,
            ),
            elevation: 5,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
