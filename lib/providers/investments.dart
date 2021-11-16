import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvestmentItem {
  final String id;
  final String stockLabel;
  final String stockName;
  final String stockExchange;

  InvestmentItem({
    required this.id,
    required this.stockLabel,
    required this.stockName,
    required this.stockExchange,
  });
}

class Investments with ChangeNotifier {
  List<InvestmentItem> _userInvestments = [];
  List _urlStocks = [];

  final String token;
  final String userId;

  Investments(this.token, this.userId, this._userInvestments);

  // get method to get the list of stocks the user saved
  List<InvestmentItem> get getUserInvestmentsList {
    return [..._userInvestments];
  }

  // get method to get the list of stocks the API returned based on user search
  List get getUrlStocks {
    return [..._urlStocks];
  }

  // method to fetch and store stocks details based on user search
  // text parameter is the user search value
  Future<void> searchLabel(String text) async {
    // url string to API
    final String urlString =
        "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$text&apikey=NDESB25P2USI9V9L";

    // parsing the url and sending get request to API
    final url = Uri.parse(urlString);
    final response = await http.get(url);

    // extracting the API response and storing it
    final extractedStocksData =
        json.decode(response.body) as Map<String, dynamic>;

    // an empty list for storing the values returned by API
    var myStocksList = [];

    // looping over all the returned stocks details by API
    for (var stock in extractedStocksData['bestMatches']) {
      // addinf the stock in the list only if it is from region INDIA
      if (stock['4. region'] == 'India/Bombay') {
        myStocksList.add({
          'symbol': stock['1. symbol'],
          'name': stock['2. name'],
        });
      }
    }

    // setting the value and notify listeners
    _urlStocks = myStocksList;
    notifyListeners();
  }

  // method to delete or empty url stocks lists when user changes tab
  // or searches for other stocks
  void emptyUserSearch() {
    // if stocks are present then only empty the list
    if (_urlStocks.isNotEmpty) {
      _urlStocks = [];
    }
    notifyListeners();
  }
}
