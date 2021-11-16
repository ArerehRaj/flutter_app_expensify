import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key, required this.typeOfScreen})
      : super(key: key);
  final String typeOfScreen;

  @override
  Widget build(BuildContext context) {
    var textMessage = 'Daily transactions';
    if (typeOfScreen == 'monthly_transactions') {
      textMessage = 'Monthly transactions';
    } else if (typeOfScreen == 'investments') {
      textMessage = 'Investments';
    }
    return Expanded(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No $textMessage added yet!',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.normal,
                  fontSize: 45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: constraints.maxHeight * 0.3,
                child: Image.asset(
                  'assets/images/emptyBox.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
