import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

// class which defines how a dialy transaction should look like
class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  // Constructor
  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

class Transactions with ChangeNotifier {
  // List of Transactions
  List<TransactionItem> _transactions = [];

  final String token;
  final String userId;

  Transactions(
    this.token,
    this.userId,
    this._transactions,
  );

  // get function to get the copy of transaction list
  List<TransactionItem> get getTransactions {
    return [..._transactions];
  }

  // get function to get the Transaction item object from the list
  TransactionItem getTransactionById(String id) {
    return _transactions.firstWhere((transaction) => transaction.id == id);
  }

  // async function to add a new transaction over firebase
  Future<void> addTransaction(
      double amount, DateTime date, String title) async {
    // url to save the transaction for the user
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId.json?auth=$token');

    // post request to send over the url to firebase
    final response = await http.post(
      url,
      // sending json encoded data
      body: json.encode(
        {
          'amount': amount,
          'dateTime': date.toIso8601String(),
          'title': title,
        },
      ),
    );
    // adding the transaction in transaction
    //list to render over the user's UI
    _transactions.add(
      TransactionItem(
        id: json.decode(response.body)['name'],
        title: title,
        amount: amount,
        date: date,
      ),
    );
    notifyListeners();
  }

  // async function to add fetch and set the transaction
  // data from the firebase in user's UI
  Future<void> fetchAndSetTransactions() async {
    // url to fetch the data from firebase
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId.json?auth=$token');

    // sending get request to firebase
    final response = await http.get(url);

    // creating a empty list for loading transactions from firebase
    final List<TransactionItem> loadedTransactions = [];

    // if the response.body is null i.e. no transactions
    // for the user then return
    if (response.body == 'null') {
      return;
    }

    // extracting the transaction data from the
    // response.body in the form of a map
    final extractedTransactionData =
        json.decode(response.body) as Map<String, dynamic>;

    // if extracted data is null then return
    if (extractedTransactionData == null) {
      return;
    }

    // for each transaction we are looping and
    // adding in it the loaded transaction list by creating
    // new transaction item objects
    extractedTransactionData.forEach((transactionId, transactionData) {
      loadedTransactions.add(
        TransactionItem(
          id: transactionId,
          title: transactionData['title'],
          amount: transactionData['amount'],
          date: DateTime.parse(transactionData['dateTime']),
        ),
      );
    });

    // setting the loaded transactions to our class
    // transaction list which is used over the app
    _transactions = loadedTransactions;
    notifyListeners();
  }

  // async function to delete a transaction from firebase of that user
  // and update in user's UI
  Future<void> deleteTransaction(String id) async {
    // getting the index of that transaction from transaction list
    final existingTransactionIndex =
        _transactions.indexWhere((trx) => trx.id == id);

    // fetching the transaction item object from our class transaction list
    var existingTransaction = _transactions[existingTransactionIndex];

    // url to delete that particular transaction of the user from the firebase
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId/$id.json?auth=$token');

    // removing the transaction from our class
    // transaction list and updating the UI
    _transactions.removeAt(existingTransactionIndex);
    notifyListeners();

    // sending the delete request over firebase
    final response = await http.delete(url);

    // if the response status code is greater than 400 then there is error in request
    // so dont delete the transaction and add it once again in the list and update user's UI
    if (response.statusCode >= 400) {
      _transactions.insert(existingTransactionIndex, existingTransaction);
      notifyListeners();

      // throw exception here
      throw HttpException('An error occured while Deleting!');
    }
  }
}
