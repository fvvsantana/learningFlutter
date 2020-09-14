import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:meals/widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const String routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
      ),
      drawer: MainDrawer(),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Text(
            'Adjust your meal selection',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
        SwitchListTile.adaptive(
          title: const Text('Gluten-free'),
          value: _glutenFree,
          onChanged: (value) {
            setState(() {
              _glutenFree = value;
            });
          },
          subtitle: const Text('Only include gluter-free meals.'),
        ),
        SwitchListTile.adaptive(
          title: const Text('Lactose-free'),
          value: _lactoseFree,
          onChanged: (value) {
            setState(() {
              _lactoseFree = value;
            });
          },
          subtitle: const Text('Only include lactose-free meals.'),
        ),
        SwitchListTile.adaptive(
          title: const Text('Vegetarian'),
          value: _vegetarian,
          onChanged: (value) {
            setState(() {
              _vegetarian = value;
            });
          },
          subtitle: const Text('Only include vegetarian meals.'),
        ),
        SwitchListTile.adaptive(
          title: const Text('Vegan'),
          value: _vegan,
          onChanged: (value) {
            setState(() {
              _vegan = value;
            });
          },
          subtitle: const Text('Only include vegan meals.'),
        ),
      ]),
    );
  }
}
