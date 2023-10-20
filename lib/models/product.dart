// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/products_variants_categories.dart';

class Product{
  late String id;
  late String name;
  late String image;
  late double availableStock;
  late double onCartAmount;
  late double sellingPrice;
  late double buyingPrice;
  late double discount = 0.0;
  late Rx<List<ProductsVariantsCategory>>  variantCategories = Rx<List<ProductsVariantsCategory>>([]);
  
  late String businessId;
  late Timestamp  createdAt;
  Product();
  Product.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    image = documentSnapshot["image"];
    businessId= documentSnapshot["businessId"];
    createdAt= documentSnapshot["createdAt"];
  }
}