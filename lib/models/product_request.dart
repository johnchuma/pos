import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';

class ProductRequest{
  late String request;
  late String image;
  late String to;
  late String from;
  late Client? client;
  late String productId;
  late List businessesThatSentTheirOffers = [];
  late Rx<List<Business>> businesses  =Rx<List<Business>>([]);
  late Timestamp createdAt;
  late String id;
  ProductRequest();
  ProductRequest.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    request = documentSnapshot["request"];
    image = documentSnapshot["image"];
    productId = documentSnapshot["productId"];
    to = documentSnapshot["to"];
    from = documentSnapshot["from"];
    businessesThatSentTheirOffers = documentSnapshot["businessesThatSentTheirOffers"];
    createdAt = documentSnapshot["createdAt"];
    id = documentSnapshot["id"];


  }
}