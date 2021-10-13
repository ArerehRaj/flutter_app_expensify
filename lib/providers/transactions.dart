import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

class Transactions with ChangeNotifier {
  List<TransactionItem> _transactions = [];

  final String token;
  final String userId;

  Transactions(
    this.token,
    this.userId,
    this._transactions,
  );

  List<TransactionItem> get getTransactions {
    return [..._transactions];
  }

  TransactionItem getTransactionById(String id) {
    return _transactions.firstWhere((transaction) => transaction.id == id);
  }

  Future<void> addTransaction(
      double amount, DateTime date, String title) async {
    // final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId.json?auth=$token');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': amount,
          'dateTime': date.toIso8601String(),
          'title': title,
        },
      ),
    );
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

  Future<void> fetchAndSetTransactions() async {
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId.json?auth=$token');
    final response = await http.get(url);
    final List<TransactionItem> loadedTransactions = [];
    if (response.body == 'null') {
      return;
    }
    final extractedTransactionData =
        json.decode(response.body) as Map<String, dynamic>;

    if (extractedTransactionData == null) {
      return;
    }
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
    _transactions = loadedTransactions;
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final existingTransactionIndex =
        _transactions.indexWhere((trx) => trx.id == id);
    var existingTransaction = _transactions[existingTransactionIndex];
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/daily_transactions/$userId/$id.json?auth=$token');
    _transactions.removeAt(existingTransactionIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _transactions.insert(existingTransactionIndex, existingTransaction);
      notifyListeners();

      // throw exception here
      throw HttpException('An error occured while Deleting!');
    }
  }
}
