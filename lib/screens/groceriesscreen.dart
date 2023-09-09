import 'package:flutter/material.dart';
import 'package:shoppinglist_app/data/dummy_items.dart';
import 'package:shoppinglist_app/models/grocery_item.dart';
import 'package:shoppinglist_app/screens/new_item.dart';
import 'package:shoppinglist_app/widgets/grocerylist_item.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<GroceryItem> groceryItemList = groceryItems;

  void _addItem() async {
    final GroceryItem? groceryitem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewItemScreen(
          groceryItemList: groceryItemList,
        ),
      ),
    );
    if (groceryitem == null) {
      return;
    }
    setState(() {
      groceryItemList.add(groceryitem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: [
          ...groceryItemList
              .map(
                (item) => Dismissible(
                  key: Key(item.id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      groceryItemList.remove(item);
                    });
                  },
                  direction: DismissDirection.startToEnd,
                  child: GroceryListItem(groceryitem: item),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
