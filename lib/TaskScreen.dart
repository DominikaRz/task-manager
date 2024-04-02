import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:task_manager/Type.dart';

class TaskScreen extends StatefulWidget {
  //for adding option
  final Function(Map<String, dynamic>) onSubmit;
  const TaskScreen({required this.onSubmit});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();

//initiate the variables
  String _title = '';
  String _description = '';
  String _date = '';
  String _type = types[0];
  bool _status = false;

  @override
  Widget build(BuildContext context) {
    DateTime _fromDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Title:
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the title of the task.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              //Description:
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'You are missing the description!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              //Type:
              DropdownButton<String>(
                value: _type,
                isExpanded: true,
                onChanged: (String? value) {
                  setState(() {
                    _type = value!;
                  });
                },
                items: List<DropdownMenuItem<String>>.generate(types.length,
                    (index) {
                  return DropdownMenuItem<String>(
                    value: types[index],
                    child: Row(
                      children: [
                        Icon(icons[index], color: Colors.grey),
                        SizedBox(width: 10),
                        Text(types[index])
                      ],
                    ),
                  );
                }),
              ),
              //Date:
              FormBuilderDateTimePicker(
                name: 'date_time',
                decoration: const InputDecoration(
                  labelText: 'Due date',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please add due date.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _date = DateFormat('yyyy-MM-dd kk:mm').format(value!);
                },
              ),
              //Submit:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final title = _title;
                      final description = _description;
                      widget.onSubmit({
                        'title': title,
                        'description': description,
                        'type': _type,
                        'date': _date,
                        'status': _status
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
