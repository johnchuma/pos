
// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/product.dart';


class SellController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Product>> productsReceiver = Rx<List<Product>>([]);
        List<Product> get products => productsReceiver.value;
      
        Rx<Product> selectedProduct = Rx<Product>(Product());
          Rx<List<Product>> onCartProducts = Rx<List<Product>>([]);
          Rx<double> totalCartAmount = Rx<double>(0.0);
          Rx<String> searchKeyword = Rx<String>("");
          var inventoryCalculationProgress = 0.obs;
          Rx<bool> loading = Rx<bool>(false);
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Product>> getProducts() {
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
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
   Future<List<Product>> getSampleBusinessProduct() async{
              List<Product> products = [];
              QuerySnapshot businessSnapshot = await firestore
              .collection("businesses").where("category",isEqualTo: businessController.selectedBusiness.value?.category).where("isSampleBusiness",isEqualTo: true)
              .get();

              if(businessSnapshot.docs.length >0){
                  Business business = Business.fromDocumentSnapshot(businessSnapshot.docs.first);
                  QuerySnapshot querySnapshot  = await firestore
                  .collection("products").where("businessId",isEqualTo: business.id).orderBy("createdAt",descending: true)
                  .get();
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                  products.add(product);
                  }
              }
         
            return products;  
        }
        
 
         Stream<List<Product>> getSupplierPublicProducts() {
        
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedSupplier.value?.id).where("isPublic",isEqualTo: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) {
               List<Product> products = [];
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                 
              
                      products.add(product);

                }
   

            return products;    
          });
        }

            Stream<List<Product>> getProductsWithStockSelling() {
   
        loading.value = true;
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Product> products = [];
               inventoryCalculationProgress.value = 0;
               int number = 0;
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
              firestore.collection("stocks").where("productId",isEqualTo: element["id"]).get().then((querySnapshot) {
              firestore.collection("sales").where("productId",isEqualTo: element["id"]).get().then((salesQuerySnapshot) {
                 double totalStocks = 0;
                  double totalSoldStocks = 0;
                  for (var stocks in querySnapshot.docs) {
                    totalStocks = totalStocks + stocks["amount"];
                  }
                   for (var sale in salesQuerySnapshot.docs) {
                    totalSoldStocks = totalSoldStocks + sale["amount"];
                  }
                  if(querySnapshot.docs.length > 0){
                      product.availableStock.value = totalStocks - totalSoldStocks;
                  }
                 
                          
           });
         });
         number++;
        print("it is going");
                      products.add(product);

                  }
        loading.value = false;

            return products;    
          });
        }
     
       Stream<List<Product>> getProductsWithStock() {
   
        loading.value = true;
          return firestore
              .collection("products").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Product> products = [];
               int number = 0;
               int length = querySnapshot.docs.length;
                  for (var element in querySnapshot.docs) {
                  Product product = Product.fromDocumentSnapshot(element);
                 
         QuerySnapshot querySnapshot =    await  firestore.collection("stocks").where("productId",isEqualTo: element["id"]).get();
           var salesQuerySnapshot =      await firestore.collection("sales").where("productId",isEqualTo: element["id"]).get();
         double totalStocks = 0;
                  double totalSoldStocks = 0;
                  for (var stocks in querySnapshot.docs) {
                    totalStocks = totalStocks + stocks["amount"];
                  }
                   for (var sale in salesQuerySnapshot.docs) {
                    totalSoldStocks = totalSoldStocks + sale["amount"];
                  }
                  if(querySnapshot.docs.length > 0){
                      product.availableStock.value = totalStocks - totalSoldStocks;
                  }
                  if(product.availableStock.value>0){
                      products.add(product);
                  }
                    number++;
                      print(number);
                      print(length);
                      // print((number/length))
                      inventoryCalculationProgress.value = ((number/length)*100).round();
                 
                }

              
        loading.value = false;
        
            return products;    
          });
        }
     
     Future<void> addNormalProduct (name,imageFile,properties)async{
          try {
            var productId = Timestamp.now().toDate().toString();
             var imagelink =  await authController.getImageLink(imageFile);
           await  firestore.collection("products").doc(productId).set({
              "id":productId,
              "name":name,
              "updatedAt":Timestamp.now(),
              "businessId":businessController.selectedBusiness.value?.id,
              "image":imagelink,
              "properties":properties,
              "sellingPrice":0.0,
              "measurement":"",
              "category":businessController.selectedBusiness.value?.category,
              "lowAmount":0.0,
              "offerPrice":0.0,
              "isCheap":false,
              "otherImages":[],
              "buyingPrice":0.0,
              "isPublic":false,
              "allowDiscount":false,
              "createdAt":Timestamp.now()
            });
        
          } catch (e) {
          }
      }


     
        @override
        void onInit() {
          productsReceiver.bindStream(getProductsWithStockSelling());
          // productsWithStockReceiver.bindStream(getProductsWithStock());
          super.onInit();
        }
}