import 'package:flutter/material.dart';
import 'package:shoppinglist_app/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.groceryitem});

  final GroceryItem groceryitem;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration:
                  BoxDecoration(color: groceryitem.category.categoryBlockColor),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(groceryitem.name),
            const Spacer(), // occupies all space that can be occupied between the widget that is before it , and the widgets that are after it.
            Text(groceryitem.quantity.toString()),
          ],
        ),
      ),
    );
  }
}
