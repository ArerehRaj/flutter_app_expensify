import 'package:expensify_app/widgets/chart.dart';
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
  var _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    Provider.of<Transactions>(context, listen: false)
        .fetchAndSetTransactions()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
    final transactionsData = Provider.of<Transactions>(context);
    final deviceSize = MediaQuery.of(context).size;

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              if (transactionsData.getTransactions.isNotEmpty)
                Container(
                    height: deviceSize.height * 0.25,
                    child: Chart(transactionsData.getTransactions)),
              Container(
                // child: transactionsData.getTransactions.isEmpty
                // height: deviceSize.height * 0.75,
                child: transactionsData.getTransactions.isEmpty
                    ? Expanded(
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            return Column(
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
                                  height: 10,
                                ),
                                Container(
                                  height: constraints.maxHeight * 0.3,
                                  child: Image.asset(
                                    'assets/images/emptyBox.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            return ti_widget.TransactionItem(
                              transaction:
                                  transactionsData.getTransactions[index],
                            );
                          },
                          itemCount: transactionsData.getTransactions.length,
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
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
