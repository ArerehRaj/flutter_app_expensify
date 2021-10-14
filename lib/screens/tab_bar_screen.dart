import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/daily_transactions.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    // creating a default tab bar of length 3 with intial index as 0
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
          // setting the titles for each tab
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
          actions: [
            // this add 3 dot icon at the top
            PopupMenuButton(
              // on selecting the logout option this code gets
              // executed and the user gets logout
              onSelected: (result) {
                if (result == 0) {
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                }
              },
              itemBuilder: (_) => [
                // option 1 i.e. logout
                const PopupMenuItem(
                  child: Text('Logout'),
                  value: 0, // setting the value to 0
                ),
              ],
              // icon for verticle 3 dots
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        // setting the screens to show based on selected tab
        body: TabBarView(
          children: [
            DailyTransactions(),
            const AuthScreen(),
            const AuthScreen(),
          ],
        ),
      ),
    );
  }
}
