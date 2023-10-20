import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/register.dart';

class StaffRegister{

  late String id;
  late String staffId;
  late String password;
  late Register register;
  late List permissions = [];
  late Timestamp createdAt;
  late String registerId;
  
  StaffRegister();
  StaffRegister.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    createdAt = documentSnapshot["createdAt"];
    staffId = documentSnapshot["staffId"];
    permissions = documentSnapshot["permissions"];
    registerId = documentSnapshot["registerId"];
    password = documentSnapshot["password"];
    

  }
  
}
