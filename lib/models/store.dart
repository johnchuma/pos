import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/product.dart';

class Store{
  late String name;
  late Rx<List<Product>> products= Rx<List<Product>>([]);
  Store();
  Store.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    name = documentSnapshot["name"];
  }
}