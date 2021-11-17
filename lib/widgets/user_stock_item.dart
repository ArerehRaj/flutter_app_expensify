import 'package:flutter/material.dart';

class UserStockItem extends StatelessWidget {
  const UserStockItem({
    Key? key,
    required this.symbol,
    required this.name,
    required this.stockId,
    required this.stockExchange,
  }) : super(key: key);

  final String symbol;
  final String name;
  final String stockId;
  final String stockExchange;

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
                  '$symbol | $stockExchange',
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
                  name,
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
                const Text(
                  '₹100',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lato',
                  ),
                ),
                Container(
                  height: 25,
                  width: 55,
                  child: const Text('-1.0%'),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
