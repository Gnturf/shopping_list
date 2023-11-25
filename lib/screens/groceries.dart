import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

import 'package:http/http.dart' as http;

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() {
    return _GroceriesState();
  }
}

class _GroceriesState extends State<Groceries> {
  List<GroceryItem> _groceryItems = [];

  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
      'flutte-shopping-list-9dda5-default-rtdb.asia-southeast1.firebasedatabase.app',
      'shopping-list.json',
    );

    try {
      final r = await http.get(url);

      if (r.statusCode >= 400) {
        setState(() {
          _error = "Failed To Fetch Data";
        });
        return;
      }

      if (r.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Prev: Map<String, Map<String, dynamic>> | WWhy? The data type was too specific
      final Map<String, dynamic> listData = json.decode(r.body);
      final List<GroceryItem> _loadedItem = [];

      for (var data in listData.entries) {
        final category = categories.entries.firstWhere(
          (element) {
            return element.value.label == data.value["category"];
          },
        ).value;

        _loadedItem.add(
          GroceryItem(
            id: data.key,
            name: data.value["name"],
            quantity: data.value["quantity"],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = [..._loadedItem];
        _isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        _error = "No Internet Connection";
      });
    }
  }

  void _addItem() async {
    final _newGroceryItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItem();
        },
      ),
    );

    if (_newGroceryItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(_newGroceryItem);
    });
  }

  void _removeItem(GroceryItem groceryItem) async {
    final index = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.remove(groceryItem);
    });

    final url = Uri.https(
      'flutter-shopping-list-9dda5-default-rtdb.asia-southeast1.firebasedatabase.app',
      'shopping-list/${groceryItem.id}.json',
    );

    final r = await http.delete(url);

    if (r.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _currScreen = const Center(
      child: Text(
        'No Item Yet\nTry Adding 1?',
        textAlign: TextAlign.center,
      ),
    );

    if (_isLoading) {
      _currScreen = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      _currScreen = GroceryList(
        groceries: _groceryItems,
        onRemoved: _removeItem,
      );
    }

    if (_error != null) {
      _currScreen = Center(
        child: Text(
          _error!,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _currScreen,
    );
  }
}
