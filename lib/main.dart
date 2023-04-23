import 'package:flutter/material.dart';
import 'package:mis_lab03/exams_list.dart';
import 'package:mis_lab03/model/Exam.dart';
import 'package:mis_lab03/new_exam.dart';
import 'package:mis_lab03/widgets/calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationItem {
  final DateTime date;
  final String title;
  final String description;

  NotificationItem(this.date, this.title, this.description);
}

const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('main_channel', 'Main Channel',
        channelDescription: 'ashwin',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
const NotificationDetails notificationDetails = NotificationDetails(
  android: androidNotificationDetails,
  iOS: DarwinNotificationDetails(
    sound: 'default.wav',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '181169 - Flutter Lab 04',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              return MyHomePage();
            } else {
              return LoginWidget();
            }
          },
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  List<Exam> exams = [];

  void addNewExam(String courseName, DateTime examDateTime) {
    Random random = new Random();
    var exam = Exam(
        id: random.nextInt(1000).toString(),
        courseName: courseName,
        examDateTime: examDateTime,
        userId: FirebaseAuth.instance.currentUser!.uid);

    addExamToDB(exam: exam);
    scheduleNotifications(exams);

    setState(() {
      exams.add(exam);
    });
  }

  Future<void> scheduleNotifications(exams) async {
    for (var i = 0; i < exams.length; i++) {
      NotificationItem notification = NotificationItem(
          exams[i].examDateTime, exams[i].courseName, "Your exam is starting");
      await flutterLocalNotificationsPlugin.schedule(i, notification.title,
          notification.description, notification.date, notificationDetails);
    }
  }

  Future addExamToDB({required Exam exam}) async {
    final docItem =
        FirebaseFirestore.instance.collection('examsList').doc(exam.id);
    final json = exam.toJson();
    await docItem.set(json);
  }

  Future<List<Exam>> readItems() => FirebaseFirestore.instance
      .collection('examsList')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((response) => response.docs
          .map((element) => Exam.fromJson(element.data()))
          .toList());

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

  void removeExam(int index) async {
    await deleteCourse(index);
    setState(() => {exams.removeAt(index)});
  }

  Future deleteCourse(int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('examsList')
          .doc(exams[index].id)
          .delete();
    } catch (e) {
      return false;
    }
  }

  void _showCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calendar(events: exams.toList())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lab 04"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openNewExamDialog(context),
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            color: Colors.black,
          )
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Text(
                "Logged in user:",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder<List<Exam>>(
                future: readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Error! ${snapshot.error.toString()}",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    );
                  } else if (snapshot.hasData) {
                    exams = snapshot.data!;
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        child: exams.isEmpty
                            ? const Text('There are no exams entered!',
                                textAlign: TextAlign.center)
                            : ExamsList(exams: exams, removeExam: removeExam));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
            //   ),
            ),
        ElevatedButton(
          onPressed: _showCalendar,
          child: const Text(
            "Calendar",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
        ),
      ]),
    );
  }
}
