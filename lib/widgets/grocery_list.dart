import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/grocery_list_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({
    super.key,
    required this.groceries,
    required this.onRemoved,
  });

  final List<GroceryItem> groceries;
  final Function(GroceryItem groceryItem) onRemoved;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(
            groceries[index],
          ),
          child: GroceryListItem(
            grocery: groceries[index],
          ),
          onDismissed: (direction) {
            onRemoved(groceries[index]);
          },
        );
      },
    );
  }
}
