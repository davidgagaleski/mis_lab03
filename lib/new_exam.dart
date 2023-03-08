import 'package:flutter/material.dart';

class NewExam extends StatefulWidget {
  final Function(String, String) addNewExam;
  const NewExam({Key? key, required this.addNewExam}) : super(key: key);

  @override
  _NewExamState createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final courseNameController = TextEditingController();
  final dateAndTimeController = TextEditingController();

  void submitData() {
    if (courseNameController.text.isNotEmpty &&
        dateAndTimeController.text.isNotEmpty) {
      widget.addNewExam(
        courseNameController.text,
        dateAndTimeController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                controller: courseNameController,
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Date and time of course exam',
                  border: OutlineInputBorder(),
                ),
                controller: dateAndTimeController,
              ),
              TextButton(
                onPressed: submitData,
                child: const Text('Submit exam'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
