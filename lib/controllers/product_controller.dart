
// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_variants_controller.dart';
import 'package:pos/models/product.dart';
import 'package:pos/models/products_variants_categories.dart';
import 'package:pos/models/variant_item.dart';

class ProductController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Product>> productsReceiver = Rx<List<Product>>([]);
        List<Product> get products => productsReceiver.value;
          Rx<List<Product>> productsWithStockReceiver = Rx<List<Product>>([]);
        
        List<Product> get productsWithStock => productsWithStockReceiver.value;
        Rx<Product> selectedProduct = Rx<Product>(Product());
          Rx<List<Product>> onCartProducts = Rx<List<Product>>([]);
          Rx<double> totalCartAmount = Rx<double>(0.0);
          Rx<String> searchKeyword = Rx<String>("");

        AuthController authController = Get.find<AuthController>();
        ProductVariantsController  productVariantsController = Get.find<ProductVariantsController>();
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Product>> getProducts() {
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedBusiness.value.id)
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

  Future populateProductVariants({Product? product})async{
        Product productToBeUsed = product??selectedProduct.value;
           QuerySnapshot querySnapshot =await  firestore.collection("products").doc(productToBeUsed.id).collection("variantsCategories").get();
          List<ProductsVariantsCategory> categories = [];
          for (var doc in querySnapshot.docs) {
              ProductsVariantsCategory category = await productVariantsController.getCategory(doc["categoryId"]);
             QuerySnapshot querySnapshot2 = await firestore.collection("products").doc(productToBeUsed.id).collection("variantsCategories").doc(doc["id"]).collection("variants").get();
               for (var doc2 in querySnapshot2.docs) {
                 VariantItem variant = await productVariantsController.getVariant(category.id, doc2["variantId"]);
                 category.variants.value.add(variant);
               }
               categories.add(category);
          }
        
          if(product != null){
           product.variantCategories.value = categories;
          }
          else{
          selectedProduct.value.variantCategories.value = categories;

          }
         
      }
    
       Stream<List<Product>> getProductsWithStock() {
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedBusiness.value.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                 
                  QuerySnapshot querySnapshot = await firestore.collection("stocks").where("productId",isEqualTo: element["id"]).get();
                  QuerySnapshot salesQuerySnapshot = await firestore.collection("sales").where("productId",isEqualTo: element["id"]).get();
                  double totalStocks = 0;
                  double totalSoldStocks = 0;

                  
                  for (var stocks in querySnapshot.docs) {
                    totalStocks = totalStocks + stocks["amount"];
                  }
                   for (var sale in salesQuerySnapshot.docs) {
                    totalSoldStocks = totalSoldStocks + sale["amount"];
                  }
                  if(querySnapshot.docs.length > 0){
                      product.availableStock = totalStocks - totalSoldStocks;
                      product.sellingPrice = querySnapshot.docs.last["sellingPrice"];
                      product.buyingPrice = querySnapshot.docs.last["buyingPrice"];
                      products.add(product);
                  }
                }
            return products;    
          });
        }
    
     Future<void> addNormalProduct (name,imageFile)async{
          try {
            var productId = Timestamp.now().toDate().toString();
             var imagelink =  await authController.getImageLink(imageFile);
           await  firestore.collection("products").doc(productId).set({
              "id":productId,
              "name":name,
              "businessId":businessController.selectedBusiness.value.id,
              "image":imagelink,
              "createdAt":Timestamp.now()
            });
        
              for (var category in productVariantsController.selectedCategories.value) {
            var categoryId = Timestamp.now().toDate().toString();
                await firestore.collection("products").doc(productId).collection("variantsCategories").doc(categoryId).set({
                  "id":categoryId,
                  "categoryId":category.id
                });
                for (var variant in category.selectedVariants.value) {
                var variantId = Timestamp.now().toDate().toString();     
                  await firestore.collection("products").doc(productId).collection("variantsCategories").doc(categoryId).collection("variants").doc(variantId).set({
                  "id":variantId,
                  "categoryId":categoryId,
                  "variantId":variant.id
                });
                }
            }
          } catch (e) {
          }
      }
       
        Future<void> deleteProduct (productId) async{
          try {
           await firestore.collection("products").doc(productId).delete();
          } catch (e) {
          }
       }
       
        @override
        void onInit() {
          productsReceiver.bindStream(getProducts());
          productsWithStockReceiver.bindStream(getProductsWithStock());
          super.onInit();
        }
}