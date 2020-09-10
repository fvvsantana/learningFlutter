import 'package:flutter/material.dart';

class CategoryMealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Name'),
      ),
      body: Center(
        child: Text('Delicious meals'),
      ),
    );
  }
}
