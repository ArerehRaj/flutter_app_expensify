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
      body: DashboardGrid(),
    );
  }
}
