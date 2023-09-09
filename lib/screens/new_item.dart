import 'package:flutter/material.dart';
import 'package:shoppinglist_app/data/categories.dart';
import 'package:shoppinglist_app/models/grocery_item.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key, required this.groceryItemList});

  final List<GroceryItem> groceryItemList;

  @override
  State<NewItemScreen> createState() {
    return _NewItemScreenState();
  }
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<
      FormState>(); // this is a key associated with the form that we use , it enables us to use multiple form features like validation , etc...

  var _enteredName = '';
  var _enteredQuantity = 1;
  var _enteredCategory = categories[Categories.vegetables];
  late List<GroceryItem> groceryItemList;

  @override
  void initState() {
    super.initState();
    groceryItemList = widget.groceryItemList;
  }

  void _saveItem() {
    // this is a method that can be used to validate a form , it basically calls the function that we have written inside the validator parameter.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final groceryitem = GroceryItem(
        id: (groceryItemList.length + 1),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _enteredCategory!,
      );
      Navigator.of(context).pop(groceryitem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          // this is a widget that enables various other widgets that would be helpful to generate a form.
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // as in expense tracker we used the textfield widget , here we use the textformfield widget because we are inside a form.
                maxLength: 50,
                decoration: const InputDecoration(
                  // we can add decoration to our textfield (like labels)
                  label: Text('Name'),
                ),
                validator: (value) {
                  // this is basically a function inside which we put the logic to validate the text that is entered by the user in the field , so that value parameter passed by flutter is basically the value (text) entered by the user.
                  if ((value == null) ||
                      (value.isEmpty) ||
                      (value.trim().length <= 1) ||
                      (value.trim().length > 50)) {
                    return 'Must be between 2 and 50 characters long !';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if ((value == null) ||
                            (value.isEmpty) ||
                            (int.tryParse(value) == null) ||
                            (int.tryParse(value)! <= 0)) {
                          return 'Must be a valid positive number!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.tryParse(value!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _enteredCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: category.value.categoryBlockColor),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _enteredCategory = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Submit Form'),
                  ),
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset Form'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
