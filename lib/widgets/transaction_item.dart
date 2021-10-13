import 'package:expensify_app/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transactions.dart' as ti;

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  final ti.TransactionItem transaction;
  // TransactionItem(this.transaction);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final scaffold = ScaffoldMessenger.of(context);
    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        color: Theme.of(context).errorColor.withOpacity(0.25),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        try {
          Provider.of<ti.Transactions>(context, listen: false)
              .deleteTransaction(transaction.id);
        } catch (error) {
          scaffold.showSnackBar(
            const SnackBar(
              content: Text(
                'Deleting Failed',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are you sure?',
            ),
            content: const Text('Do you want to remove the transaction?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                child: Text('₹${transaction.amount}'),
              ),
            ),
          ),
          title: Text(transaction.title),
          subtitle: Text(
            DateFormat.yMMMd().format(transaction.date),
          ),
        ),
      ),
    );
  }
}
