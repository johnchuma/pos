import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance{
  late Timestamp checkInTime;
  late Timestamp checkOutTime;
  late String id;
  late String staffId;
  late Timestamp createdAt;


  Attendance();
  Attendance.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    checkInTime = documentSnapshot["checkInTime"];
    checkOutTime = documentSnapshot["checkOutTime"];
    id = documentSnapshot["id"];
    staffId = documentSnapshot["staffId"];
    createdAt = documentSnapshot["createdAt"];

  }
}