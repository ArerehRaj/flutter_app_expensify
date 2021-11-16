import 'package:expensify_app/widgets/monthly_transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../providers/investments.dart';
import '../widgets/no_transactions.dart';
import '../widgets/new_transaction_form.dart';

class MonthlyTransactions extends StatefulWidget {
  const MonthlyTransactions({Key? key}) : super(key: key);

  @override
  State<MonthlyTransactions> createState() => _MonthlyTransactionsState();
}

class _MonthlyTransactionsState extends State<MonthlyTransactions> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;

    // provider call to delete user search details of stocks if exists
    final investmentData = Provider.of<Investments>(context, listen: false);
    if (investmentData.getUrlStocks.isNotEmpty) {
      investmentData.emptyUserSearch();
    }

    Provider.of<Transactions>(context, listen: false)
        .fetchAndSetTransactions('monthly_transactions')
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
              mode: TransactionMode.monthly,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyTransactionData = Provider.of<Transactions>(context);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              monthlyTransactionData.getMonthlyTransactions.isEmpty
                  ? const NoTransactions(
                      typeOfScreen: 'monthly_transactions',
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => MonthlyTransactionItem(
                          monthlyTransactionData.getListOfMap[index].key,
                          monthlyTransactionData
                              .getListOfMap[index].value['total'],
                          monthlyTransactionData
                              .getListOfMap[index].value['transactions'],
                        ),
                        itemCount: monthlyTransactionData
                            .getMonthlyTransactions.length,
                      ),
                    ),
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
