import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../widgets/transaction_item.dart' as ti_widget;
import '../widgets/new_transaction_form.dart';

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

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: const NewTransactionForm(
              mode: TransactionMode.daily,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        if (transactionsData.getTransactions.isNotEmpty) const Text('CHART'),
        Container(
          // child: transactionsData.getTransactions.isEmpty
          height: deviceSize.height * 0.6,
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
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: deviceSize.height * 0.18,
                      child: Image.asset(
                        'assets/images/emptyBox.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
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
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
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
