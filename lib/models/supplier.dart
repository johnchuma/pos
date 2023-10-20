import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';

class Supplier{
  late String id;
  late String businessId;
  late Business supplier;
  late Timestamp createdAt;

  Supplier();
  Supplier.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    businessId = documentSnapshot["businessId"]; 
    createdAt = documentSnapshot["createdAt"];
  }
}