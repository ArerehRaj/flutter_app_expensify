import 'package:expensify_app/providers/investments.dart';
import 'package:flutter/material.dart';

class UserStockItem extends StatelessWidget {
  const UserStockItem({
    Key? key,
    // required this.symbol,
    // required this.name,
    // required this.stockId,
    // required this.stockExchange,
    required this.stock,
  }) : super(key: key);

  // final String symbol;
  // final String name;
  // final String stockId;
  // final String stockExchange;

  final InvestmentItem stock;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(5),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stock.stockLabel} | ${stock.stockExchange}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  stock.stockName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Lato',
                  ),
                )
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '₹${stock.closePrice}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
                Container(
                  height: 25,
                  width: 55,
                  child: Text(
                    '${stock.percentage.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: stock.isProfit ? Colors.green : Colors.red,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
