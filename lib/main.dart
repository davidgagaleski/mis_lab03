import 'package:flutter/material.dart';
import 'package:mis_lab03/exams_list.dart';
import 'package:mis_lab03/model/Exam.dart';
import 'package:mis_lab03/new_exam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '181169 - Flutter Lab 03',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '181169 - Flutter Lab 03'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Exam> exams = [
    const Exam(
      courseName: 'Mobilni informaciski sistemi',
      examDateTime: '03.03.2023 15:00',
    ),
    const Exam(
      courseName: 'Kompjuterska Etika',
      examDateTime: '07.03.2023 15:00',
    ),
    const Exam(
      courseName: 'Diplomska rabota',
      examDateTime: '16.06.2023 11:30',
    ),
  ];

  void addNewExam(String courseName, String examDateTime) {
    var exam = Exam(courseName: courseName, examDateTime: examDateTime);

    setState(() {
      exams.add(exam);
    });
  }

  void openNewExamDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bCtx) {
        return GestureDetector(
          child: NewExam(
            addNewExam: addNewExam,
          ),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void removeExam(int index) {
    setState(() {
      exams.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openNewExamDialog(context),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: exams.length <= 0
            ? const Text('There are no exams entered!',
                textAlign: TextAlign.center)
            : ExamsList(exams: exams, removeExam: removeExam),
      ),
    );
  }
}
