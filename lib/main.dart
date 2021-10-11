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
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Transactions>(
          update: (ctx, auth, previousTransactions) => Transactions(
            auth.token,
            auth.userID,
            previousTransactions == null
                ? []
                : previousTransactions.getTransactions,
          ),
          create: (_) => Transactions('', '', []),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            fontFamily: 'Lato',
          ),
          title: 'Expensify',
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
          routes: {
            DailyTransactions.routeName: (ctx) => DailyTransactions(),
          },
        ),
      ),
    );
  }
}
