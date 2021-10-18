import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/transactions.dart';

import './screens/auth_screen.dart';
import './screens/tab_bar_screen.dart';
import './screens/daily_transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for Authentication
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // Proxy Provider for Authentication and Transactions both
        ChangeNotifierProxyProvider<Auth, Transactions>(
          update: (ctx, auth, previousTransactions) => Transactions.daily(
            auth.token,
            auth.userID,
            previousTransactions == null
                ? []
                : previousTransactions.getTransactions,
          ),
          create: (_) => Transactions.daily('', '', []),
        ),
        ChangeNotifierProxyProvider<Auth, Transactions>(
          update: (ctx, auth, previousTransactions) => Transactions.monthly(
            auth.token,
            auth.userID,
            previousTransactions == null
                ? {}
                : previousTransactions.getMonthlyTransactions,
          ),
          create: (_) => Transactions.monthly('', '', {}),
        ),
      ],
      // Consumer set up for authentication incase of
      //changes in screen during authentication
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          // set the basic general theme of app
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            fontFamily: 'Lato',
          ),
          title: 'Expensify',
          // if the user is authenticated take the user to home tab screen
          // else we will check if the user has auth token else take the user
          // to auth screen
          home: auth.isAuthenticated
              ? TabBarScreen()
              : FutureBuilder(
                  builder: (ctx, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          // setting the basic routes here for whole app
          routes: {
            DailyTransactions.routeName: (ctx) => DailyTransactions(),
          },
        ),
      ),
    );
  }
}
