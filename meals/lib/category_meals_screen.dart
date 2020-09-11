import 'package:flutter/material.dart';

import './dummy_data.dart';
import './models/meal.dart';

class CategoryMealsScreen extends StatelessWidget {
  static final routeName = '/category-meals';

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryId = arg['id'];
    final categoryTitle = arg['title'];
    final List<Meal> meals =
        DUMMY_MEALS.where((meal) => meal.categories.contains(categoryId)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
          child: Column(
        children: meals.map((meal) => Text(meal.title)).toList(),
      )),
    );
  }
}
