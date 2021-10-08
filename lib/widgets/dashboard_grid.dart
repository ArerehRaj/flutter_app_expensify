import 'package:flutter/material.dart';

class DashboardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imagesList = [
      'assets/images/expenses.png',
      'assets/images/budgetTracking.png',
      'assets/images/stock.png',
      'assets/images/settings.png',
    ];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: imagesList.length,
      itemBuilder: (ctx, index) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
          child: GridTile(
            child: Image.asset(
              imagesList[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
