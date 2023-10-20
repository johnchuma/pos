import 'package:cloud_firestore/cloud_firestore.dart';

class Register {
  late String id;
  late String title;
  late String description;
  late Timestamp createdAt;

  Register();
  Register.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id  = documentSnapshot["id"];
    title  = documentSnapshot["title"];
    description  = documentSnapshot["description"];
    createdAt  = documentSnapshot["createdAt"];

  }
}