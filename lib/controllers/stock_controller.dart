
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/models/Stock.dart';
import 'package:pos/models/variant_item.dart';

class StockController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Stock>> stocksReceiver = Rx<List<Stock>>([]);
        List<Stock> get stocks => stocksReceiver.value;
        Rx<Stock> selectedStock = Rx<Stock>(Stock());
        AuthController authController = Get.find<AuthController>();
        Rx<VariantItem?> selectedVariant = Rx<VariantItem?>(null);
        BusinessController businessController = Get.find<BusinessController>();
        ProductController productController = Get.find<ProductController>();
        Stream<List<Stock>> getStocks() {
          return firestore
              .collection("stocks").where("productId",isEqualTo: productController.selectedProduct.value.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Stock> stocks = [];
                  for (var element in querySnapshot.docs) {
                  Stock stock = Stock.fromDocumentSnapshot(element);
                  stocks.add(stock);
                }
            return stocks;    
          });
        }
    Future<Stock?> getLastAddedProductStock (productId)async{
          try {
          
          QuerySnapshot querySnapshot =   await  firestore.collection("stocks").where("productId",isEqualTo: productId).get();
           Stock? stock;
           if(querySnapshot.docs.isNotEmpty){
           stock =  Stock.fromDocumentSnapshot(querySnapshot.docs.last) ;
           }
         return stock;
          } catch (e) {
            print(e);
          }
      }
     Future<void> addStock (amount, buyingPrice, sellingPrice)async{
          try {
            var id = Timestamp.now().toDate().toString();
            await productController.updateProduct(productController.selectedProduct.value.id, {
               "buyingPrice": double.parse(buyingPrice),
               "sellingPrice": double.parse(sellingPrice),
            });
           await  firestore.collection("stocks").doc(id).set({
              "id":id,
              "amount":double.parse(amount),
              "productId":productController.selectedProduct.value.id,
              "buyingPrice": double.parse(buyingPrice),
              "sellingPrice": double.parse(sellingPrice),
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteStock (stockId)async{
          try {
           await  firestore.collection("stocks").doc(stockId).delete();
          } catch (e) {
            print(e);
          }
      }
       



        @override
        void onInit() {
        stocksReceiver.bindStream(getStocks());
          super.onInit();
        }
}