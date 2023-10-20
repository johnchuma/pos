import 'package:cloud_firestore/cloud_firestore.dart';

class Tutorial{
  late String title;
  late String video;
  late String id;
  late Timestamp createdAt;
  Tutorial();
  Tutorial.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    title = documentSnapshot["title"];
    id = documentSnapshot["id"];
    video = documentSnapshot["video"];
    createdAt = documentSnapshot["createdAt"];
  }
  
}