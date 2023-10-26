// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/products_variants_categories.dart';

class Product{
  late String id;
  late String name;
  late String image;
  late Rx<double> availableStock = Rx<double> (0.0);
  late double onCartAmount;
  late double sellingPrice = 0.0;
  late double buyingPrice = 0.0;
  late double discount = 0.0;
  late Rx<bool> isPublic =Rx<bool>(false);
  late Rx<List<ProductsVariantsCategory>>  variantCategories = Rx<List<ProductsVariantsCategory>>([]);
  late Rx<Business?> business = Rx<Business?>(null);
  late String businessId;
  late List properties  = [];
  late Timestamp  createdAt;
  Product();
  Product.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    name = documentSnapshot["name"];
    image = documentSnapshot["image"];
    isPublic.value = documentSnapshot["isPublic"];
    properties = documentSnapshot["properties"];
    sellingPrice = documentSnapshot["sellingPrice"] ;
    buyingPrice = documentSnapshot["buyingPrice"] ;
    businessId= documentSnapshot["businessId"];
    createdAt= documentSnapshot["createdAt"];
  }
}