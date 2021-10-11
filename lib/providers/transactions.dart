import 'package:flutter/cupertino.dart';

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

  void addTransaction(TransactionItem newTransaction) {
    _transactions.add(newTransaction);
    notifyListeners();
  }

  void fetchAndSetTransactions() {
    print('IN FECT');
    notifyListeners();
  }
}
