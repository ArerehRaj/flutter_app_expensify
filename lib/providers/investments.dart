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

  // method to get the details of stock like prices, profit or loss and percentage
  Future<Map> getStockDetails(String symbol) async {
    // url string to API for that stock
    final String urlString =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$symbol&apikey=NDESB25P2USI9V9L';
    final url = Uri.parse(urlString);
    // get request to API
    final response = await http.get(url);

    // Extracting the stock data as a Map
    final extractedStockData =
        json.decode(response.body) as Map<String, dynamic>;

    // fetching only the date and time related details of the stock
    final stockData =
        extractedStockData['Time Series (Daily)'] as Map<String, dynamic>;
    // final todaysTimeStamp = DateTime.now().toString().split(" ")[0];

    // temp map to store the data
    var data = {};

    // fetching the first key of the map i.e. the latest date and data of that stock
    final key = stockData.keys.toList().first;

    // fetching the close and open price of the stock
    final closePrice = double.parse(stockData[key]['4. close']);
    final openPrice = double.parse(stockData[key]['1. open']);

    // calculating that day's price
    final daysPrice = closePrice - openPrice;

    // setting a bool value for profit or not
    bool isProfit = true;

    // if day's price is negative then set profit to false
    if (daysPrice < 0) {
      isProfit = false;
    }

    // calculating the percentage and storing the data in the map
    final percentage = (daysPrice / openPrice) * 100;
    data['isProfit'] = isProfit;
    data['percentage'] = percentage;
    data['closePrice'] = closePrice;
    data['date'] = key;

    // if loss then set the negative value of percentage as positive
    if (!isProfit) {
      data['percentage'] = -data['percentage'];
    }

    // return the map
    return data;
  }

  // bool function to check if the stock already exists in the user list or not
  bool checkIfStockPresent(String label) {
    // if error throws up then it means the stock is not present in list
    // else present
    try {
      var stock = _userInvestments
          .singleWhere((stockObject) => stockObject.stockLabel == label);
      if (stock != null) {
        print('present');
        return true;
      }
      print('not present');
      return false;
    } catch (error) {
      print('not present');
      return false;
    }
  }

  // method to add a user stock in firebase
  Future<void> addStockInUserList(String label, String name) async {
    // url string to API for storing the stock details of that user on firebase
    final String urlString =
        'https://expensify-8324b-default-rtdb.firebaseio.com/userStocks/$userId.json?auth=$token';
    final url = Uri.parse(urlString);

    // temp variable to store stock details
    var stockDetails;

    // fetching and storing the stock details
    await getStockDetails(label).then((value) => stockDetails = value);

    // sending the post request with the stock details
    final response = await http.post(
      url,
      body: json.encode(
        {
          'name': name,
          'symbol': label,
          'isProfit': stockDetails['isProfit'],
          'percentage': stockDetails['percentage'],
          'closePrice': stockDetails['closePrice'],
          'date': stockDetails['date'],
        },
      ),
    );

    // adding in the user investments list and updating the UI of user by notify listners
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

  // function to update the stock details stored on firebase
  Future<void> updateStockDetails(
      String stockId, String symbol, String name) async {
    // url to update the specific stock stored on firebase using REST API
    final url = Uri.parse(
        'https://expensify-8324b-default-rtdb.firebaseio.com/userStocks/$userId/$stockId.json?auth=$token');

    // temp var for storing new updated details
    var stockDetails;

    // storing the updated stock details
    await getStockDetails(symbol).then((value) => stockDetails = value);

    // patch or update request to udpate the stock details on firebase with new details of the stock
    await http.patch(
      url,
      body: json.encode(
        {
          'name': name,
          'symbol': symbol,
          'isProfit': stockDetails['isProfit'],
          'percentage': stockDetails['percentage'],
          'closePrice': stockDetails['closePrice'],
          'date': stockDetails['date'],
        },
      ),
    );
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

    // string value of todays date
    final todaysTimeStamp = DateTime.now().toString().split(" ")[0];

    // DateTime object of todays date using the string value
    final todaysDate = DateFormat('yyyy-M-d').parse(todaysTimeStamp);

    // new date for checking for updates
    var newDate =
        DateTime(todaysDate.year, todaysDate.month, todaysDate.day - 2);

    var new_date =
        DateTime(todaysDate.year, todaysDate.month, todaysDate.day - 4);

    // var to check if update is done or not
    var isUpdate = false;

    // looping over each stock which was returned from firebase
    extractedUserStocks.forEach((userStockId, userStock) {
      // getting the stored stock date
      var storedStockDate = DateFormat('yyyy-M-d').parse(userStock['date']);
      // condition for update of stocks
      if ((storedStockDate == newDate || storedStockDate == new_date) &&
          (todaysDate.weekday != 6 || todaysDate.weekday != 7)) {
        // update the stocks details and update is set to true
        isUpdate = true;
        print('In update');
        // calling the update function
        updateStockDetails(
          userStockId,
          userStock['symbol'],
          userStock['name'],
        );
      }
      // if no update then simply add in the list
      else {
        print('Not update');
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
      }
    });

    // in case of no upadtes then simply show the data on users screen else fetch and
    // set the data once again for new values
    if (!isUpdate) {
      // setting it to user investments list and notifying the listners
      _userInvestments = loadedUserStocks;
    } else {
      fetchAndSetUserStocks();
    }
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
