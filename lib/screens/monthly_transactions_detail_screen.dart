import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/transactions.dart';

class MonthlyTransactionDetailScreen extends StatelessWidget {
  static const routeName = '/detail-view';

  @override
  Widget build(BuildContext context) {
    // fetching the arguments passed in the pushNamed function
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    // fetching the month and the list of transactions of that month
    final String month = args['month'].toString();
    final List monthlyTransactions = args['transactions'] as List;
    return Scaffold(
      appBar: AppBar(
        title: Text(month),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child:
                      // setting a list tile here
                      ListTile(
                    // circular avatar for showing the amount in it
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('₹${monthlyTransactions[index].amount}'),
                        ),
                      ),
                    ),
                    // showing the title
                    title: Text(monthlyTransactions[index].title),
                    // showing the sub title --> date
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(monthlyTransactions[index].date),
                    ),
                  ),
                );
              },
              itemCount: monthlyTransactions.length,
            ),
          ),
        ],
      ),
    );
  }
}
