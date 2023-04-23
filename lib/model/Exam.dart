import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Exam {
  final String courseName;
  final DateTime examDateTime;
  final String id;
  final String userId;

  final FirebaseAuth auth = FirebaseAuth.instance;
  Exam({
    required this.id,
    required this.userId,
    required this.courseName,
    required this.examDateTime,
  }) {}

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': auth.currentUser!.uid,
        'courseName': courseName,
        'examDateTime': examDateTime
      };

  static Exam fromJson(Map<String, dynamic> json) => Exam(
      id: json['id'],
      userId: json['userId'],
      courseName: json['courseName'],
      examDateTime: (json['examDateTime'] as Timestamp).toDate());
}
