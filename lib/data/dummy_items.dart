import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/models/grocery_item.dart';

final groceryItems = [
  GroceryItem(
      id: 1,
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 2,
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 3,
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];