import 'package:expensify_app/providers/investments.dart';
import 'package:expensify_app/widgets/transaction_item.dart';
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
  List<TransactionItem> _dailyTransactions = [];

  // Map to store the details of monthly transactions
  Map<int, Map<String, Object>> _monthlyTransactions = {};

  final String token;
  final String userId;

  // constructor for daily transactions
  Transactions.daily(
    this.token,
    this.userId,
    this._dailyTransactions,
  );

  // constructor for monthly transactions
  Transactions.monthly(
    this.token,
    this.userId,
    this._monthlyTransactions,
  );

  // get function to return the list of map for monthly transactions
  List get getListOfMap {
    return [..._monthlyTransactions.entries.toList()].reversed.toList();
  }

  // get function to get the copy of daily transaction list
  List<TransactionItem> get getTransactions {
    return [..._dailyTransactions];
  }

  // fet function to get the copy of monthly transactions map
  Map<int, Map<String, Object>> get getMonthlyTransactions {
    return {..._monthlyTransactions};
  }

  // get function to get the Transaction item object from the list
  TransactionItem getTransactionById(String id) {
    return _dailyTransactions.firstWhere((transaction) => transaction.id == id);
  }

  // async function to add a new transaction over firebase
  Future<void> addTransaction(
      double amount, DateTime date, String title, String identifier) async {
    // url to save the transaction for the user based of identifier
    // identifier can be either monthly_transactions or
    // daily_transactions as value
    var urlString =
        'https://expensify-8324b-default-rtdb.firebaseio.com/$identifier/$userId.json?auth=$token';

    var response;

    // checking if the request is for daily_transactions
    if (identifier == 'daily_transactions') {
      // parsing the url for daily_transactions
      final url = Uri.parse(urlString);

      // sending the post request for daily_transactions to firebase
      response = await http.post(
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
      // list to render over the user's UI
      _dailyTransactions.add(
        TransactionItem(
          id: json.decode(response.body)['name'],
          title: title,
          amount: amount,
          date: date,
        ),
      );
    }
    // checking if the request is for monthly_transactions
    else if (identifier == 'monthly_transactions') {
      // updating the string to upload for a specific month number
      urlString =
          'https://expensify-8324b-default-rtdb.firebaseio.com/$identifier/$userId/${date.month}.json?auth=$token';

      // parsing the url for daily_transactions
      final url = Uri.parse(urlString);

      // sending the post request for monthly_transactions to firebase
      response = await http.post(
        url,
        body: json.encode(
          {
            'amount': amount,
            'title': title,
            'dateTime': date.toIso8601String(),
          },
        ),
      );

      // checking if the new monthly transaction's month number is not in firebase
      // then create and store here with empty values
      if (_monthlyTransactions[date.month] == null) {
        _monthlyTransactions[date.month] = {'total': 0.0, 'transactions': []};
      }

      // var to store the new total for that month
      var newTotal =
          double.parse(_monthlyTransactions[date.month]!['total'].toString()) +
              amount;
      _monthlyTransactions[date.month]!['total'] = newTotal;

      // new list with the new added transactions
      final newList = _monthlyTransactions[date.month]!['transactions'] as List;

      // adding the transaction in transaction
      // list of the map to render over the user's UI
      newList.add(
        TransactionItem(
          id: json.decode(response.body)['name'],
          title: title,
          amount: amount,
          date: date,
        ),
      );
    }
    notifyListeners();
  }

  // async function to add fetch and set the transaction
  // data from the firebase in user's UI
  Future<void> fetchAndSetTransactions(String identifier) async {
    // url to fetch the data from firebase
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/$identifier/$userId.json?auth=$token');

    // sending get request to firebase
    final response = await http.get(url);

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

    if (identifier == 'daily_transactions') {
      // creating a new empty list for loading the transactions from firebase
      final List<TransactionItem> loadedTransactions = [];

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

      // updating the loaded transaction to render the users UI
      _dailyTransactions = loadedTransactions;
    }
    // checking for monthly transactions
    else if (identifier == 'monthly_transactions') {
      // empty map for monthly transactions
      final Map<int, Map<String, Object>> loadedTransactions = {};

      // looping over each month and its transactions to calculate the total sum
      // of that month and adding the transactions in a list
      extractedTransactionData.forEach((monthNumber, monthlyTransactions) {
        // set the vars for total and list
        var total = 0.0;
        final trx_list = [];

        // setting the value as empty map for that particular month
        loadedTransactions[int.parse(monthNumber)] = {};

        // looping over each transactions for that month
        monthlyTransactions.forEach((transactionId, transactionData) {
          // addiing the sum of amount
          total += transactionData['amount'];

          // adding the transaction item in the list
          trx_list.add(
            TransactionItem(
              id: transactionId,
              title: transactionData['title'],
              amount: transactionData['amount'],
              date: DateTime.parse(transactionData['dateTime']),
            ),
          );
        });
        // updating the value in map to render at users UI
        loadedTransactions[int.parse(monthNumber)]!['total'] = total;
        loadedTransactions[int.parse(monthNumber)]!['transactions'] = trx_list;
      });
      _monthlyTransactions = loadedTransactions;
    }

    notifyListeners();
  }

  // async function to delete a transaction from firebase of that user
  // and update in user's UI
  Future<void> deleteTransaction(String id) async {
    // getting the index of that transaction from transaction list
    final existingTransactionIndex =
        _dailyTransactions.indexWhere((trx) => trx.id == id);

    // fetching the transaction item object from our class transaction list
    var existingTransaction = _dailyTransactions[existingTransactionIndex];

    // url to delete that particular transaction of the user from the firebase
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId/$id.json?auth=$token');

    // removing the transaction from our class
    // transaction list and updating the UI
    _dailyTransactions.removeAt(existingTransactionIndex);
    notifyListeners();

    // sending the delete request over firebase
    final response = await http.delete(url);

    // if the response status code is greater than 400 then there is error in request
    // so dont delete the transaction and add it once again in the list and update user's UI
    if (response.statusCode >= 400) {
      _dailyTransactions.insert(existingTransactionIndex, existingTransaction);
      notifyListeners();

      // throw exception here
      throw HttpException('An error occured while Deleting!');
    }
  }
}
