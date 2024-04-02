/*
  Write a tasks manager app in which: 

  (2p.) User can add at least 4 types of tasks (for example: todo, email, phone, meeting etc.) 
  (2p.) Each task has: 
    Title, 
    Description, 
    Due date, 
    Status (done/ not done) 
    Icon (depends on type). 
  (1p.) Application should have action bar with “+” action to add new task. 
  (2p.) Main app screen include list of all tasks. Each list item should have icon, title, due date and status. 
  (1p.) After click on the item user see new screen with all data about selected task. 
  (1p.) Swipe left on item mark it as done. 
  (1p.) Swipe right remove the specific item. 
*/

/*
  Additionally implemented: 
  - saving list on mobile devices
  - undo remove the item form list
  - undo steeing task to done
  - unsetting the task to done (only to done ones)
  - added one more type: exercise
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:task_manager/ListScreen.dart';
import 'package:task_manager/TaskScreen.dart';
import 'package:task_manager/DetailsScreen.dart';

void main() {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tasks = [];
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ListScreen(),
    );
  }
}

//for better look
MaterialColor deepPurple = MaterialColor(
  0xFF311B92,
  <int, Color>{},
);
