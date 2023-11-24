import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({
    super.key,
    required this.grocery,
  });

  final GroceryItem grocery;

  @override
  Widget build(BuildContext context) {
    // Version 1
    // return Padding(
    //   padding: const EdgeInsets.all(14),
    //   child: Row(
    //     children: [
    //       Container(
    //         height: 20,
    //         width: 20,
    //         color: grocery.category.color,
    //       ),
    //       const SizedBox(
    //         width: 14,
    //       ),
    //       Text(grocery.name),
    //       const Spacer(),
    //       Text(grocery.quantity.toString())
    //     ],
    //   ),
    // );

    // Version 2
    return ListTile(
      leading: Container(
        height: 24,
        width: 24,
        color: grocery.category.color,
      ),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
