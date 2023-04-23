import 'package:flutter/material.dart';
import 'package:mis_lab03/model/Exam.dart';
import 'package:intl/intl.dart';

class ExamsList extends StatelessWidget {
  final List<Exam> exams;
  final Function(int) removeExam;

  const ExamsList({
    Key? key,
    required this.exams,
    required this.removeExam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 5,
          child: ListTile(
            title: Text(
              exams[index].courseName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                "${DateFormat("dd/MM/yyyy h:mma").format(exams[index].examDateTime)}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => removeExam(index),
            ),
          ),
        );
      },
      itemCount: exams.length,
    );
  }
}
