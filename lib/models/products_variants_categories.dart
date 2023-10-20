import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pos/models/variant_item.dart';

class ProductsVariantsCategory{
  late String id;
  late String title;
  late Timestamp createdAt;
  late String businessId;
  late Rx<List<VariantItem>> variants = Rx<List<VariantItem>>([]);
  late Rx<List<VariantItem>> selectedVariants = Rx<List<VariantItem>>([]);

  ProductsVariantsCategory();
  ProductsVariantsCategory.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
      id = documentSnapshot["id"];
      title = documentSnapshot["title"];
      createdAt = documentSnapshot["createdAt"];
      businessId = documentSnapshot["businessId"];

  }
}