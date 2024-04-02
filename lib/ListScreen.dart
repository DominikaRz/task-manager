import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:task_manager/TaskScreen.dart';
import 'package:task_manager/Type.dart';
import 'package:task_manager/DetailsScreen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List items = []; //list of tasks
  Map<String, dynamic>? lastRemovedItem; //used for undo function
  int? lastRemovedIndex; //used for undo function

// Assigning icons to types
  IconData _getLeadingIcon(String type) {
    switch (type) {
      case 'todo':
        return icons[0];
      case 'email':
        return icons[1];
      case 'phone':
        return icons[2];
      case 'meeting':
        return icons[3];
      case 'excercise':
        return icons[4];
      default:
        return Icons.error_outline;
    }
  }

// Fetch content from the json file (Worning: works only on mobile!)
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data1.json');
    final data = await json.decode(response);
    setState(() {
      items = data['items'];
    });
  }

// Save list to JSON file (Worning: works only on mobile!)
  Future<void> saveTasks(List<dynamic> task) async {
    final file = File('assets/data1.json');
    await file.writeAsString(jsonEncode(task));
  }

// Add element form form to list
  void addItem(Map<String, dynamic> task) {
    setState(() {
      items.add(task);
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of all tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              saveTasks(items);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task saved to file'),
                ),
              );
            },
          ),
        ],
      ),
      body: items.isNotEmpty
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Color cardColor = Colors.white; // default color for done tasks
                if (items[index]['completed'] == true) {
                  cardColor = Colors.grey[300]!; // gray color for undone tasks
                }
                return Slidable(
                  //provide slide action
                  key: Key(index.toString()),
                  //removing the task
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        autoClose: true,
                        flex: 1,
                        onPressed: (value) {
                          lastRemovedItem = items[index];
                          lastRemovedIndex = index;
                          items.removeAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            //show undo
                            SnackBar(
                              content:
                                  Text('${lastRemovedItem!['title']} removed'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    items.insert(
                                        lastRemovedIndex!, lastRemovedItem!);
                                    lastRemovedItem = null;
                                    lastRemovedIndex = null;
                                  });
                                },
                              ),
                            ),
                          );
                          setState(() {}); // Update state to refresh list
                        },
                        //see the panel below task
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  //marked task as done (if state = undone) or undone (if state = done)
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      //when swipe: mark as undone if done
                      if (items[index]["completed"] != true)
                        SlidableAction(
                          autoClose: true,
                          flex: 1,
                          onPressed: (value) {
                            setState(() {
                              items[index]["completed"] = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //show undo
                              content: Text(
                                  '${items[index]["title"]} marked as done'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    items[index]["completed"] = false;
                                  });
                                },
                              ),
                            ));
                            setState(() {}); // Update state to refresh list
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check_box,
                          label: 'Check',
                        ),
                      //when swipe: mark as undone if done
                      if (items[index]["completed"] == true)
                        SlidableAction(
                          autoClose: true,
                          flex: 1,
                          onPressed: (value) {
                            setState(() {
                              items[index]["completed"] = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //show undo
                              content: Text(
                                  '${items[index]["title"]} marked as done'),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  setState(() {
                                    items[index]["completed"] = false;
                                  });
                                },
                              ),
                            ));
                            setState(() {}); // Update state to refresh list
                          },
                          //see the panel below task
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check_box_outline_blank,
                          label: 'Unheck',
                        ),
                    ],
                  ),
                  //provide details when click on task (DetailsScreen.dart)
                  child: Container(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        TaskDetail(item: items[index]),
                      );
                    },
                    //show tasks with icon, title, date and status
                    //(colors of card: done - gray, undone: white)
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(5),
                            color: cardColor,
                            child: ListTile(
                              leading:
                                  Icon(_getLeadingIcon(items[index]["type"])),
                              title: Text(items[index]["title"]),
                              subtitle: Text(
                                items[index]["date"],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                );
              },
            )
          //when listis empty show statement:
          : const Center(
              child: Text("Your List is Empty",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
      //show add button at the bottom right to add new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //navigate to page with form
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => TaskScreen(onSubmit: addItem),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
