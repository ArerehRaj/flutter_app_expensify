import 'package:expensify_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/transactions.dart';

// chart class to show the chart card and its bars
class Chart extends StatelessWidget {
  // storing recent transactions through constructor
  final List<TransactionItem> recentTransactions;
  Chart(this.recentTransactions);

  // function to return a list of map for generating transaction values in last 7 days
  List<Map<String, Object>> get generateTransactionValues {
    return List.generate(7, (index) {
      // getting the week day
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      // setting the total sum for that day to 0
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // returning the map with the info
      // of which day and that days spent amount
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
    // reversing the order and storing it as list
  }

  // function to get the total spending amount for that week
  double get totalSpending {
    return generateTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  // setting the chart card in this build method
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // for each transaction we are generating the data
          // and creating the chart bar object
          children: generateTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'].toString(),
                spendAmount: data['amount'] as double,
                // if the total spending is 0 then set the value to 0
                // or else set the data
                spendAmountPercentage: totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
