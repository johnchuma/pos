import 'package:cloud_firestore/cloud_firestore.dart';

class VariantItem{
  late String id;
  late Timestamp createdAt;
  late String name;
  VariantItem();
  VariantItem.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    createdAt = documentSnapshot["createdAt"];
    name = documentSnapshot["name"];
  }
}