import 'package:expensify_app/screens/auth_screen.dart';
import 'package:expensify_app/screens/home_dashboard_screen.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.money,
                ),
                text: 'Daily Transaction',
              ),
              Tab(
                icon: Icon(
                  Icons.calendar_today_outlined,
                ),
                text: 'Monthly Transactions',
              ),
              Tab(
                icon: Icon(
                  Icons.leaderboard,
                ),
                text: 'Investments',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // HomeDashboardScreen(),
            AuthScreen(),
            AuthScreen(),
            AuthScreen(),
            // HomeDashboardScreen(),
          ],
        ),
      ),
    );
  }
}