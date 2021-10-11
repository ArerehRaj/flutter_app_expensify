import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';

class DailyTransactions extends StatelessWidget {
  static const routeName = '/daily-transaction';

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      child: transactionsData.transactions.isEmpty
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
                  height: deviceSize.height * 0.3,
                  child: Image.asset(
                    'assets/images/emptyBox.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('Your Transactions!'),
            ),
    );
  }
}
