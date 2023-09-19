import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/models/category.dart';
import 'package:shoppinglist_app/models/grocery_item.dart';
import 'package:shoppinglist_app/screens/new_item.dart';
import 'package:shoppinglist_app/widgets/grocerylist_item.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  List<GroceryItem> groceryItemList = [];
  bool startGroceryScreen = false;
  String? _error;
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    try {
      final url = Uri.https(
        'shopping-list-backend-62169-default-rtdb.firebaseio.com',
        //'lawda.firebaseio.com'
        'shopping-list.json',
      );
      final response = await http.get(url);

      if (response.body == 'null') {
        startGroceryScreen = true;
        return;
      }

      print(response.statusCode);
      final Map<String, dynamic>? listData = json.decode(response.body);
      startGroceryScreen = true;
      final List<GroceryItem> loadedItems = [];
      for (final item in listData!.entries) {
        late final Category itemCategory;
        for (final mapitem in categories.entries) {
          if (item.value["category"] == mapitem.value.title) {
            itemCategory = mapitem.value;
            break;
          }
        }
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: itemCategory,
          ),
        );
      }
      setState(() {
        groceryItemList = loadedItems;
      });
    } catch (error) {
      setState(() {
        _error = 'error is {$error}';
      });
    }
  }

  void _addItem() async {
    final groceryItemResponse = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItemScreen(
          groceryItemList: groceryItemList,
        ),
      ),
    );
    setState(() {
      groceryItemList.add(groceryItemResponse!);
    });
    //_loadItems(); // calling this function is redundant over here , because we want to add an item, so we can directly add it inside a list within setstate clause
  }

  void _removeItem(GroceryItem item) {
    final url = Uri.https(
      'shopping-list-backend-62169-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    http.delete(url);
    setState(() {
      groceryItemList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final logic1List = groceryItemList
        .map(
          (item) => Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              _removeItem(item);
            },
            direction: DismissDirection.startToEnd,
            child: GroceryListItem(groceryitem: item),
          ),
        )
        .toList();

    Widget logic2 = const Text("Oops...nothing to show here");

    Widget logic3 = SizedBox(
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );

    List<Widget> content;
    if (_error == null) {
      if (startGroceryScreen) {
        if (groceryItemList.isEmpty) {
          content = [logic2];
        } else {
          content = logic1List;
        }
      } else {
        content = [logic3];
      }
    } else {
      content = [
        SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.paddingOf(context).top,
          child: Center(
            child: Text(_error!),
          ),
        )
      ];
    }

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
        children: content,
      ),
    );
  }
}
