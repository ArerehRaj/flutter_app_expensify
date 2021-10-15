import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../widgets/chart.dart';
import '../widgets/transaction_item.dart' as ti_widget;
import '../widgets/new_transaction_form.dart';
import '../widgets/no_transactions.dart';

class DailyTransactions extends StatefulWidget {
  static const routeName = '/daily-transaction';

  @override
  State<DailyTransactions> createState() => _DailyTransactionsState();
}

class _DailyTransactionsState extends State<DailyTransactions> {
  // setting the loading var to false
  var _isLoading = false;

  // init method which will run first while rendering the UI
  @override
  void initState() {
    // set the loading to true and will show the loading screen
    _isLoading = true;

    // calling the function to set the transaction data from firebase
    Provider.of<Transactions>(context, listen: false).fetchAndSetTransactions()
        // once the data is fetched then set the loading to false
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  // function to show the add new transaction form
  void _startAddNewTransaction(BuildContext ctx) {
    // modal bottom sheet slides up
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          // setting a gesture dectector so that in case
          // of a tap on form the sheet wont slide down
          return GestureDetector(
            onTap: () {},
            // the sheet will show the new transaction form widget
            child: const NewTransactionForm(
              mode: TransactionMode.daily,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // getting the transaction data from our provider
    final transactionsData = Provider.of<Transactions>(context);

    // getting the device size
    final deviceSize = MediaQuery.of(context).size;

    return
        // if loading is true then show the loading screen else the transactions
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // if there are transactions for the user then show the chart for that transactions
                  if (transactionsData.getTransactions.isNotEmpty)
                    Container(
                        height: deviceSize.height * 0.25,
                        child: Chart(transactionsData.getTransactions)),
                  Container(
                    // child: transactionsData.getTransactions.isEmpty
                    // height: deviceSize.height * 0.75,

                    // if there are no transactions for the user
                    // then show the message to the user
                    child: transactionsData.getTransactions.isEmpty
                        ? const NoTransactions()
                        :
                        // if there are transactions then create transaction
                        // item widget for each transaction obejct
                        Expanded(
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return ti_widget.TransactionItem(
                                  transaction:
                                      transactionsData.getTransactions[index],
                                );
                              },
                              itemCount:
                                  transactionsData.getTransactions.length,
                            ),
                          ),
                  ),
                  // setting up the add button
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: FloatingActionButton(
                      onPressed: () => _startAddNewTransaction(context),
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
