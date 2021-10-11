import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../widgets/transaction_item.dart' as ti_widget;

class DailyTransactions extends StatefulWidget {
  static const routeName = '/daily-transaction';

  @override
  State<DailyTransactions> createState() => _DailyTransactionsState();
}

class _DailyTransactionsState extends State<DailyTransactions> {
  // @override
  // void initState() {
  //   Provider.of<Transactions>(context, listen: false).fetchAndSetTransactions();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      // child: transactionsData.getTransactions.isEmpty
      height: deviceSize.height,
      child: transactionsData.getTransactions.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'No transactions added yet!',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.normal,
                    fontSize: 45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  height: deviceSize.height * 0.25,
                  child: Image.asset(
                    'assets/images/emptyBox.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            )
          :
          // Container(
          //     height: deviceSize.height * 0.7,
          //     child: Column(
          //       children: [
          //         const Text('CHART'),
          ListView.builder(
              itemBuilder: (ctx, index) {
                return ti_widget.TransactionItem(
                  transaction: TransactionItem(
                    id: '1',
                    title: 'title',
                    amount: 250,
                    date: DateTime.now(),
                  ), //transactionsData.getTransactions[index],
                );
              },
              itemCount: 2, //transactionsData.getTransactions.length,
            ),
      //],
      //),
      //),
    );
  }
}
