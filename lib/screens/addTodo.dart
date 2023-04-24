import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/homePage.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;

    if (widget.todo != null) {
      isEdit = true;
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit == true ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: 'Title'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(hintText: 'Description'),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
            onPressed: isEdit == true ? updateData : saveData,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(isEdit == true ? 'update' : 'Submit'),
            ))
      ]),
    );
  }

//create or save function
  Future<void> saveData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'content-type': 'application/json'});
    if (response.statusCode == 201) {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
      showSuccessMessage('Todo Added Successfully');
    } else {
      showErrorMessage('Todo Added Failed');
    }
  }

//update function
  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'content-type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });

      showSuccessMessage('Updated Successfully');
    } else {
      showErrorMessage('Updated Failed');
    }
  }

//for success message
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//for error message
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
