import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/product.dart';
import 'package:pos/models/store.dart';

class PublicProductsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
      Rx<List<Product>> productsReceiver = Rx<List<Product>>([]);
      Rx<Business?> selectedProductBusiness =Rx<Business?>(null);
      String? selectedCategory ;
      Rx<String> searchKeyword = Rx<String>("");
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
              .collection("products").where("isPublic",isEqualTo: true).where("businessId",isEqualTo:businessId ).orderBy("updatedAt",descending: true)
              .get();

               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
            return products;    
          
        }
Future<List<Product>> getOfferPriceProducts({limit})async {
        QuerySnapshot querySnapshot =  await firestore
              .collection("products").where("isPublic",isEqualTo: true).where("offerPrice",isNotEqualTo:0).limit(limit??10)
              .get();
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
                print(products.length);
            return products;    
          
        }

  Future<List<Product>> getAllPublicProducts({limit})async {
        QuerySnapshot querySnapshot =  await firestore
              .collection("products").where("isPublic",isEqualTo: true).limit(limit??200).orderBy("updatedAt",descending: true)
              .get();
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
                print(products.length);
            return products;    
          
        }
        Future<List<Product>> getCategoryProducts(category,{limit})async {
        QuerySnapshot querySnapshot =  await firestore
              .collection("products").where("category",isEqualTo: category).where("isPublic",isEqualTo: true).limit(limit??10).orderBy("updatedAt",descending: true)
              .get();
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
            return products;    
          
        }

         Future<List<Product>> getMoreCategoryProducts()async {
        QuerySnapshot querySnapshot =  await firestore
              .collection("products").where("category",isEqualTo: selectedCategory).where("isPublic",isEqualTo: true).limit(300).orderBy("updatedAt",descending: true)
              .get();
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                }
            return products;    
          
        }

      Future<List<Store>> getCategoriesAndTheirProducts({limit})async {
            QuerySnapshot querySnapshot =  await firestore
                  .collection("storesTypes")
                  .get();
                  List<Store> stores = [];
                      for (var element in querySnapshot.docs) {
                      Store store = Store.fromDocumentSnapshot(element);
                      store.products.value =  await getCategoryProducts(store.name,limit:limit??10 );
                      stores.add(store);
                    }
                return stores;    
              
            }
  @override
  void onInit() {
   productsReceiver.bindStream(getProducts());
    super.onInit();
  }
}