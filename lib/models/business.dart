import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/message_model.dart';
import 'package:pos/models/business_subscription.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/staff.dart';
import 'package:pos/models/staff_registers.dart';

class Business{
  late String id;
  late String name;
  late String image;
  late String description;
  late double latitude;
  late String phone;
  late double longitude;
  late String userId;
  late String category = "";
  late String role;
  late bool isSampleBusiness = false;
  late String address;
  late Client owner;
  late List<Client> staffs = [];
  late List<StaffRegister> staffRegisters;
  late List<BusinessSubscription> businesSubscriptions;
  late Rx<List<Message>> messages =Rx<List<Message>>([]);
  late Timestamp createdAt;

 Business();
 Business.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
  id = documentSnapshot["id"];
  name = documentSnapshot["name"];
  image = documentSnapshot["image"];
  description = documentSnapshot["description"];
  phone = documentSnapshot["phone"];
  latitude = documentSnapshot["latitude"];
  longitude = documentSnapshot["longitude"];
  address = documentSnapshot["address"];
  category = documentSnapshot["category"];
  role = documentSnapshot["role"];
  isSampleBusiness = documentSnapshot["isSampleBusiness"];
  userId = documentSnapshot["userId"];
  if(isSampleBusiness){
    createdAt = Timestamp.now();
  }
  else{
  createdAt = documentSnapshot["createdAt"];
  }
 }

}