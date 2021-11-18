import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class InvestmentItem {
  final String id;
  final String stockLabel;
  final String stockName;
  final String stockExchange;
  final bool isProfit;
  final double closePrice;
  final double percentage;

  InvestmentItem({
    required this.id,
    required this.stockLabel,
    required this.stockName,
    required this.stockExchange,
    required this.isProfit,
    required this.closePrice,
    required this.percentage,
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

  Future<Map> getStockDetails(String symbol) async {
    final String urlString =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$symbol&apikey=NDESB25P2USI9V9L';
    final url = Uri.parse(urlString);
    final response = await http.get(url);

    final extractedStockData =
        json.decode(response.body) as Map<String, dynamic>;

    final stockData =
        extractedStockData['Time Series (Daily)'] as Map<String, dynamic>;
    // final todaysTimeStamp = DateTime.now().toString().split(" ")[0];

    var data = {};

    final key = stockData.keys.toList().first;

    final closePrice = double.parse(stockData[key]['4. close']);
    final openPrice = double.parse(stockData[key]['1. open']);

    final daysPrice = closePrice - openPrice;
    bool isProfit = true;
    if (daysPrice < 0) {
      isProfit = false;
    }
    final percentage = (daysPrice / openPrice) * 100;
    data['isProfit'] = isProfit;
    data['percentage'] = percentage;
    data['closePrice'] = closePrice;

    if (!isProfit) {
      data['percentage'] = -data['percentage'];
    }

    return data;
  }

  Future<void> addStockInUserList(String label, String name) async {
    final String urlString =
        'https://expensify-8324b-default-rtdb.firebaseio.com/userStocks/$userId.json?auth=$token';
    final url = Uri.parse(urlString);

    var stockDetails;
    await getStockDetails(label).then((value) => stockDetails = value);

    final response = await http.post(
      url,
      body: json.encode(
        {
          'name': name,
          'symbol': label,
          'isProfit': stockDetails['isProfit'],
          'percentage': stockDetails['percentage'],
          'closePrice': stockDetails['closePrice'],
        },
      ),
    );

    _userInvestments.add(
      InvestmentItem(
        id: json.decode(response.body)['name'],
        stockLabel: label,
        stockName: name,
        stockExchange: 'BSE',
        isProfit: stockDetails['isProfit'],
        percentage: stockDetails['percentage'],
        closePrice: stockDetails['closePrice'],
      ),
    );

    notifyListeners();
  }

  // future method to fetch and set the user stocks from firebase
  Future<void> fetchAndSetUserStocks() async {
    // url or api string to fetch the stocks from firebase
    final String urlString =
        'https://expensify-8324b-default-rtdb.firebaseio.com/userStocks/$userId.json?auth=$token';
    final url = Uri.parse(urlString);

    // sending the get request to API
    final response = await http.get(url);

    // if response body is null then return
    if (response.body == 'null') {
      return;
    }

    // extracting the user stocks as a Map
    final extractedUserStocks =
        json.decode(response.body) as Map<String, dynamic>;

    // if extracted user stocks is null then return
    if (extractedUserStocks == null) {
      return;
    }

    // init a list of investment items to store the extracted stocks
    final List<InvestmentItem> loadedUserStocks = [];

    // looping over each stock which was returned from firebase
    extractedUserStocks.forEach((userStockId, userStock) {
      // adding each stock in list as an Investment item object
      loadedUserStocks.add(
        InvestmentItem(
          id: userStockId,
          stockLabel: userStock['symbol'],
          stockName: userStock['name'],
          stockExchange: 'BSE',
          isProfit: userStock['isProfit'],
          percentage: userStock['percentage'],
          closePrice: userStock['closePrice'],
        ),
      );
    });

    // setting it to user investments list and notifying the listners
    _userInvestments = loadedUserStocks;
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
