import 'package:investment/widgets/stocklist.dart';

class Stock{
  final String symbol;
  final String company;
  final double price;

  Stock({required this.symbol,required this.company,required this.price});

  static List<Stock> getAll(){
    
    // ignore: deprecated_member_use
    List<Stock> stocks=List.filled(1,Stock(company: "TATA MOTORS",symbol: "MOTOR",price: 507),growable: true); 

    // stocks.add(Stock(company: "TATA",symbol: " TATA MOTOR",price: 507));
    stocks.add(Stock(company: "TATA",symbol: "TATA POWER",price: 240));
    stocks.add(Stock(company: "VEDANTA LIMITED",symbol: "VEDL",price: 350.4));
    stocks.add(Stock(company: "BIRLA SOFT",symbol: "BIRLA",price: 417));
    stocks.add(Stock(company: "INFOSYS",symbol: "INFY",price: 1753.65));
    stocks.add(Stock(company: "ITC",symbol: "ITC",price: 244));
   
    
    return stocks;
  }
}