import 'dart:convert';

import 'package:http/http.dart' as http;
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
  bool _isSending = false;
  late List<GroceryItem> groceryItemList;

  @override
  void initState() {
    super.initState();
    groceryItemList = widget.groceryItemList;
  }

  void _saveItem() async {
    // this is a method that can be used to validate a form , it basically calls the function that we have written inside the validator parameter.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
        'shopping-list-backend-62169-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _enteredCategory!.title,
          },
        ),
      );
      print(response
          .body); // if you want to use such a response.body in your code (any value that it contains) then know that because we are getting it via http requests, it will be in json format and hence you have to first decode it to bring it into normal map (this example) format using json.decode()
      print(response.statusCode);
      final Map<String, dynamic> resData = json.decode(response.body);
      // response.statuscode --> can be used to check if everything worked, for example , 4xx and 5xx codes are for erros , and 2xx codes generally mean everything worked as expected.
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
          id: resData["name"],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _enteredCategory!,
        ),
      );
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
          key:
              _formKey, // pass that key that was previously created to this form.
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
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
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


/*

  WHAT IS JSON --> JSON IS BASICALLY A DATA TYPE (OR HOLDER) THAT CAN CONTAIN DATA IN HUMAN-READABLE FORM , AND THAT DATA CAN ALSO BE PARSED BY SYSTEM.
  THE MAIN THING HERE IS THAT WHENEVER YOU ARE DOING POST REQUESTS IN HTTP , YOU HAVE TO PUT THE DATA IN JSON FORMAT AND THEN EVERYTHING HAPPENS SMOOTHLY.

  Yes, that's a common scenario. When you're using an HTTP POST request to send data to a server (e.g., to add data to a database like Firebase), you often send that data in the JSON format. Here's a more detailed breakdown:

JSON as Payload:

When making a POST request, the data you want to send to the server is included in the body of the request. For many modern web services, this data is formatted as a JSON string.
1. HTTP Headers:

To inform the server that you're sending JSON data, you typically set the Content-Type header of your HTTP request to application/json.
2. Server Parsing:

The server, upon receiving your POST request, will check the Content-Type to understand how to parse the body. If it sees application/json, it knows to interpret the body as a JSON string and then typically converts it to whatever internal data format it uses (often still as some form of object or dictionary).
3. Database Storage:

Once the server has parsed the JSON data from the POST request, it can then take the necessary steps to save that data to a database (like Firebase in your example).
Not Exclusive to JSON:

While JSON is prevalent because of its simplicity and widespread support, some APIs and servers might accept data in other formats, like XML, form-encoded data (application/x-www-form-urlencoded), or even plain text.
In the context of Firebase, especially Firebase's Realtime Database and Cloud Firestore, data sent via HTTP requests is typically formatted as JSON. The Firebase SDKs handle this formatting for you, but if you're making direct HTTP calls to Firebase's REST API, you'd format the data as JSON yourself.
*/