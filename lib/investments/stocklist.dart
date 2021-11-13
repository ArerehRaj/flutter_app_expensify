import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investment/models/stock.dart';

class StockList extends StatelessWidget {
 
  final List<Stock> stocks;

  StockList({
    required this.stocks
  });
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context,index){
        return Divider(color: Colors.grey[400]);
      },
      itemCount: stocks.length,
      itemBuilder: (context,index){
        final stock=stocks[index];

        return ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${stock.symbol}",
              style:TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500)),
              Text("${stock.company}",
              style:TextStyle(color: Colors.grey,fontSize: 20))
              
            ],
          ),
          trailing: Column(
           crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text("\₹${stock.price}",
              style:TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500)),
              Container(
                height: 25,
                width: 55,
                child: Text("-1.0%",
                style: TextStyle(color: Colors.white),
              ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red
                ),
              )
            ],
          ),
        );
      },

    );
    
  }
}