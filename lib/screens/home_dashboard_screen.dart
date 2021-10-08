import 'package:flutter/material.dart';
import '../widgets/dashboard_grid.dart';

class HomeDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Expensify'),
            Image.asset(
              'assets/images/budget.png',
              fit: BoxFit.cover,
              height: 28,
            )
          ],
        ),
      ),
      body: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            children: [
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.2,
                child: const Center(
                  child: Text(
                    'Hello User',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DashboardGrid(),
              ),
            ],
          )),
    );
  }
}
