import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/product.dart';

class PublicProductsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
      Rx<List<Product>> productsReceiver = Rx<List<Product>>([]);
      Rx<Business?> selectedProductBusiness =Rx<Business?>(null);
        List<Product> get products => productsReceiver.value;
        Product? selectedProduct;
Stream<List<Product>> getProducts() {
          return firestore
              .collection("products").where("isPublic",isEqualTo: true).orderBy("name",descending: true).limit(60)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
            return products;    
          });
        }

Future<List<Product>> getSpecificBusinessPublicProducts({businessId})async {
        QuerySnapshot querySnapshot =  await firestore
              .collection("products").where("isPublic",isEqualTo: true).where("businessId",isEqualTo:businessId ).orderBy("name",descending: true)
              .get();

               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
            return products;    
          
        }

  @override
  void onInit() {
   productsReceiver.bindStream(getProducts());
    super.onInit();
  }
}