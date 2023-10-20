import 'package:cloud_firestore/cloud_firestore.dart';

class Store{
  late String name;
  Store();
  Store.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    name = documentSnapshot["name"];
  }
}