import 'package:sqflite/sqflite.dart';

import '../model/db_test.dart';
import '../model/grocery_test.dart';
import 'package:flutter/material.dart';

class screen_test extends StatefulWidget {
  screen_test({Key? key}) : super(key: key);

  @override
  _screen_testState createState() => _screen_testState();
}

class _screen_testState extends State<screen_test> {
  int? selectedId;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,

        ),
      ),
      body: Center(
        child: FutureBuilder<List<Grocery>>(
          future: DatabaseHelper.instance.getGroceries(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading'),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('No Groceries in List'))
                : ListView(
              children: snapshot.data!.map((grocery) {
                return Center(
                  child: Card(
                    color: selectedId == grocery.id
                        ? Colors.white70
                        : Colors.white,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          if (selectedId == null) {
                            textController.text = grocery.name;
                            selectedId = grocery.id;
                          } else {
                            textController.text = '';
                            selectedId = null;
                          }
                        });
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(grocery.name),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                DatabaseHelper.instance
                                    .remove(grocery.id!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance.update(
            Grocery(id: selectedId, name: textController.text),
          )
              : await DatabaseHelper.instance.add(
            Grocery(name: textController.text),
          );
          setState(() {
            textController.clear();
            selectedId = null;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

}