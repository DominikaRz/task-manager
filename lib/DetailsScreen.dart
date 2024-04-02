import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/Type.dart';

class TaskDetail extends PageRoute<void> {
  final dynamic item;

  TaskDetail({required this.item});

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

//for animationand background
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Color(0xE6000000).withOpacity(0.85);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Title:
                Text(
                  item['title'],
                  style: const TextStyle(color: Colors.white, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                //Type with icon:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getLeadingIcon(item['type']),
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 6),
                    Text(
                      item['type'],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                //Description:
                Text(
                  item['description'],
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                //Due date:
                Text(
                  item['date'],
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const SizedBox(height: 30),
                // Close the screen
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                )
              ],
            ),
          ),
        ));
  }
}
