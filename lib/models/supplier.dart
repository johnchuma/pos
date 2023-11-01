import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/Message_model.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';

class Supplier{
  late String id;
  late String businessId;
  late String supplierId;

  late Business supplier;
  late Business business;
  late Timestamp createdAt;
  late Rx<List<Message>> messages =Rx<List<Message>>([]);

  Supplier();
  Supplier.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    businessId = documentSnapshot["businessId"]; 
    supplierId = documentSnapshot["supplierId"]; 
    createdAt = documentSnapshot["createdAt"];
  }
}