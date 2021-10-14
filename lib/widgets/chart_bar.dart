import 'package:flutter/material.dart';

// chart bar class to show single day's spent fraction in a week
class ChartBar extends StatelessWidget {
  final String label;
  final double spendAmount;
  final double spendAmountPercentage;

  // constructor
  ChartBar({
    required this.label,
    required this.spendAmount,
    required this.spendAmountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            // showing the amount for that day in the week
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('₹${spendAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // here we are setting up the bar for that day's spent amount
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              // stack widget to stack the bars
              child: Stack(
                children: [
                  // container used to show the grey portion
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: const Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // fraction box used to show the green portion i.e. spent amount
                  FractionallySizedBox(
                    heightFactor: spendAmountPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // container to show the short form of that day
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
