import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mis_lab03/model/Exam.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewExam extends StatefulWidget {
  final Function(String, DateTime, LatLng) addNewExam;
  const NewExam({Key? key, required this.addNewExam}) : super(key: key);

  @override
  _NewExamState createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final courseNameController = TextEditingController();
  final dateAndTimeController = TextEditingController();
  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? _controller;
  List<Marker> markers = [];
  int id = 1;
  late LatLng _latLng;

  void submitData() {
    if (courseNameController.text.isNotEmpty &&
        dateAndTimeController.text.isNotEmpty) {
      widget.addNewExam(courseNameController.text,
          DateTime.parse(dateAndTimeController.text), _latLng);
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
              SizedBox(
                height: 200,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(42.0041222, 21.4073592),
                    zoom: 14,
                  ),
                  onTap: (LatLng latLng) {
                    Marker marker = Marker(
                      markerId: MarkerId('$id'),
                      position: LatLng(latLng.latitude, latLng.longitude),
                      infoWindow: InfoWindow(title: 'Location for your exam'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    );
                    markers.add(marker);
                    _latLng = latLng;
                    setState(() {});
                    id = id + 1;
                  },
                  markers: markers.map((e) => e).toSet(),
                ),
              ),
              TextButton(
                onPressed: submitData,
                child: const Text('Submit exam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
