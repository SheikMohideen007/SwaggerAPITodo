import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/utils/snackbar_message.dart';
import 'package:toast/toast.dart';

class AddEdit extends StatefulWidget {
  final String screen, id;

  const AddEdit({super.key, required this.screen, required this.id});

  @override
  State<AddEdit> createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  double devHeight = 0.0, devWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    ToastContext().init(context);
    // print(widget.screen);

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(widget.screen == 'Edit' ? 'Edit Todo' : 'ADD Todo'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          SizedBox(height: devHeight * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
            child: TextField(
              controller: title,
              decoration: InputDecoration(
                  hintText: 'Enter the title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          SizedBox(height: devHeight * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
            child: TextField(
              controller: description,
              decoration: InputDecoration(
                  hintText: 'Enter the description..',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          SizedBox(height: devHeight * 0.1),
          SizedBox(
            width: devWidth * 0.3,
            child: ElevatedButton(
                onPressed: () async {
                  if (title.text.trim() != "" &&
                      description.text.trim() != "") {
                    Map<String, dynamic> body = {
                      "title": title.text.trim(),
                      "description": description.text.trim(),
                      "is_completed": false
                    };
                    if (widget.screen == "Add") {
                      bool status =
                          await ApiService.createTodo(context, body: body);
                      if (status) {
                        SnackBarMessage.showSnackBar(
                            context, "Created Successfully", Colors.green);
                      } else {
                        SnackBarMessage.showSnackBar(
                            context, "Creation Failed", Colors.red);
                      }
                    } else {
                      bool status =
                          await ApiService.editTodo(id: widget.id, body: body);
                      if (status) {
                        SnackBarMessage.showSnackBar(
                            context, "Updated Successfully", Colors.green);
                      } else {
                        SnackBarMessage.showSnackBar(
                            context, "Updation Failed", Colors.red);
                      }
                    }

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  } else if (title.text.trim() == "" &&
                      description.text.trim() == "") {
                    Toast.show('Title and Description should not be empty');
                  } else if (title.text.trim() == "") {
                    Toast.show('Title should not be empty');
                  } else if (description.text.trim() == "") {
                    Toast.show('Description should not be empty');
                  }
                },
                child: Text(widget.screen == "Edit" ? 'Update' : 'Create')),
          )
        ],
      ),
    );
  }
}
