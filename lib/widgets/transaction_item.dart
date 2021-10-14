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
    // added Dismissnle widget for transaction item card
    // to delete it as we swipe
    return Dismissible(
      // setting the key which belongs to particular transaction object
      key: ValueKey(transaction.id),
      // setting the background features such as the
      // icon and the error red color
      background: Container(
        color: Theme.of(context).errorColor.withOpacity(0.25),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        // alignment for the icon
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ),
      // setting the direction of slide i.e. from right to left
      direction: DismissDirection.endToStart,
      // this runs a function to delete the transaction
      // from firebase for the user when the user
      // confirms to delete it
      onDismissed: (direction) {
        try {
          Provider.of<ti.Transactions>(context, listen: false)
              .deleteTransaction(transaction.id);
        } // if excpetion then show catch error and show the message as snackbar
        on HttpException catch (error) {
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
      // asking the user to confirm the dismiss i.e. delete the transaction
      // this function returns Future<bool> i.e. true then delete else dont delete
      confirmDismiss: (direction) {
        // showing a alert box to confirm the action to delete the transaction
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are you sure?',
            ),
            content: const Text('Do you want to remove the transaction?'),
            actions: [
              // if the user clicks yes then pop the alert box
              // and return true hence deleted
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
              // if the user clicks no then pop the alert box
              // and return false hence not deleted
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
      // here we are creating the card for individual transaction item
      child: Card(
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
                child: Text('₹${transaction.amount}'),
              ),
            ),
          ),
          // showing the tital
          title: Text(transaction.title),
          // showing the sub title
          subtitle: Text(
            DateFormat.yMMMd().format(transaction.date),
          ),
        ),
      ),
    );
  }
}
