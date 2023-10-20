// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/product_order.dart';

class SupplierOrder{
  late String id;
  late String businessId;
  late String supplierId;
  late bool isClosed= false;
  late bool inAppOrder ;
  late Business supplier;
  late Rx<List<ProductOrder>> productOrders = Rx<List<ProductOrder>>([]);
  bool areAllProductsDelivered(){
      int index = 0;
      for (var order in productOrders.value) {
        if(order.isDelivered.value){
          index ++;
        }
      }
      ;
      return productOrders.value.length == index;
  }
  
  late Timestamp createdAt;
  SupplierOrder();
  SupplierOrder.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    businessId = documentSnapshot["businessId"];
    supplierId = documentSnapshot["supplierId"];
    createdAt= documentSnapshot["createdAt"];
    isClosed= documentSnapshot["isClosed"];
    inAppOrder= documentSnapshot["inAppOrder"];


  }
}