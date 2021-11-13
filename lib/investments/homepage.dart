import 'package:flutter/material.dart';
import 'package:investment/models/stock.dart';
import 'package:investment/widgets/stocklist.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stocks",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("October 21st",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintStyle:TextStyle(color: Colors.grey[500]),
                          hintText: "Search",
                          prefix:Icon(Icons.search),
                          fillColor: Colors.grey[800],
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16))
                          )

                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height-310,
                    child: StockList(stocks:Stock.getAll()))
                 
                  
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
