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

    return Column(
      children: [
        Container(
          // child: transactionsData.getTransactions.isEmpty
          height: deviceSize.height * 0.65,
          child: transactionsData.getTransactions.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'No transactions added yet!',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: deviceSize.height * 0.2,
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
                  itemCount: 10, //transactionsData.getTransactions.length,
                ),
          //],
          //),
          //),
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () {
            print('HEY');
          },
          child: const Icon(
            Icons.add,
          ),
          elevation: 5,
          // focusColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
