import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/client.dart';

class Staff{
  late Client details;
  late String id;
  late Timestamp createdAt;
  late String businessId;
  
  Staff();
  Staff.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    createdAt = documentSnapshot["createdAt"];
    businessId = documentSnapshot["businessId"];
  }
}