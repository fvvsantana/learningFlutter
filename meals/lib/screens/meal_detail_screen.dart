import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  static final routeName = '/meal-detail';
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
      body: Center(
        child: Text(id),
      ),
    );
  }
}
