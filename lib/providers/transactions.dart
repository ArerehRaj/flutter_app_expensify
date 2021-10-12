import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    print(_transactions);
    return [..._transactions];
  }

  TransactionItem getTransactionById(String id) {
    return _transactions.firstWhere((transaction) => transaction.id == id);
  }

  Future<void> addTransaction(
      double amount, DateTime date, String title) async {
    final timeStamp = DateTime.now();
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

  void fetchAndSetTransactions() {
    print('IN FECT');
    notifyListeners();
  }
}
