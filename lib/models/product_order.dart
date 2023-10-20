import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/product.dart';

class ProductOrder{
  late String id;
  late String productId;
  late String supplierOrderId;
  late Rx<bool> isDelivered = Rx<bool>(false);
  late Rx<double> amount = Rx<double>(0);
  late Rx<Product?> product = Rx<Product?>(null);
  late Timestamp createdAt;
  ProductOrder.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    productId = documentSnapshot["productId"];
    supplierOrderId = documentSnapshot["supplierOrderId"];
    isDelivered.value = documentSnapshot["isDelivered"];
    amount.value = documentSnapshot["amount"];
    createdAt = documentSnapshot["createdAt"];
  }
  
}