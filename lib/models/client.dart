import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  late String id;
  late String name;
  late String email;
  late String phone ="";
  late String password ;
  late String language;
  late String role;
  late String selectedDashboard;
  late String profileImageUrl;
  late String onesignalToken;


  Client();
  Client.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    name  = documentSnapshot["name"];
    language  = documentSnapshot["language"];
    selectedDashboard  = documentSnapshot["selectedDashboard"];
    email  = documentSnapshot["email"];
    id  = documentSnapshot["email"];
    role  = documentSnapshot["role"];
    role  = documentSnapshot["role"];
    password  = documentSnapshot["password"];
    phone  = documentSnapshot["phone"];
    profileImageUrl  = documentSnapshot["profileImageUrl"];
    onesignalToken  = documentSnapshot["onesignalToken"];

  }
}