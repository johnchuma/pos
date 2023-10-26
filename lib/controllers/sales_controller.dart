
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/models/product.dart';

import 'package:pos/models/sale.dart';

class SaleController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Sale>> salesReceiver = Rx<List<Sale>>([]);
        List<Sale> get sales => salesReceiver.value;
        Rx<Sale> selectedSale = Rx<Sale>(Sale());
        Rx<int> selectedFunction = Rx<int>(0);
        Rx<String> selectedOption = Rx<String>("Today");
        Rx<DateTime?> startingDate = Rx<DateTime?>(null);
        Rx<DateTime?> endingDate = Rx<DateTime?>(null);

      BusinessController businessController = Get.find<BusinessController>();


        AuthController authController = Get.find<AuthController>();
        ProductController productController = Get.find<ProductController>();
    
      
        Future<List<Sale>> getTodaySales()async {
           DateTime now = DateTime.now();
              var from = Timestamp.fromDate(DateTime(now.year,now.month,now.day));
               var querySnapshot =await firestore
              .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id).where("createdAt",isEqualTo:from )
              .get();
               List<Sale> sales = [];
            for (var element in querySnapshot.docs) {
                  Sale sale = Sale.fromDocumentSnapshot(element);
                  DocumentSnapshot productSnapshot = await firestore.collection("products").doc(element["productId"]).get();
                   if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
                }     
            return sales;    
          
        }
          Future<List<Sale>> getYesterdaySales()async {
           DateTime now = DateTime.now();
              var from = Timestamp.fromDate(DateTime(now.year,now.month,now.day).subtract(const Duration(days: 1)));
               var querySnapshot =await firestore
              .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id).where("createdAt",isEqualTo:from )
              .get();
               List<Sale> sales = [];
            for (var element in querySnapshot.docs) {
                  Sale sale = Sale.fromDocumentSnapshot(element);
                  DocumentSnapshot productSnapshot = await firestore.collection("products").doc(element["productId"]).get();
                   if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
                }     
            return sales;    
          
        }
     

            Future<List<Sale>> getThisWeekSales() async {
              DateTime now = DateTime.now();


              DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
              DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

              var querySnapshot = await FirebaseFirestore.instance
                  .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id)
                  .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
                  .where("createdAt", isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
                  .get();

              List<Sale> sales = [];

              for (var element in querySnapshot.docs) {
                Sale sale = Sale.fromDocumentSnapshot(element);
                DocumentSnapshot productSnapshot =
                    await FirebaseFirestore.instance.collection("products").doc(element["productId"]).get();
                 if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
              }
              return sales;
            }


            Future<List<Sale>> getThisMonthSales() async {
              DateTime now = DateTime.now();

              // Calculate the start of the current month
              DateTime startOfMonth = DateTime(now.year, now.month, 1);
              Timestamp startOfMonthTimestamp = Timestamp.fromDate(startOfMonth);

              // Calculate the end of the current month
              DateTime endOfMonth = DateTime(now.year, now.month + 1, 0); // Last day of the current month
              Timestamp endOfMonthTimestamp = Timestamp.fromDate(endOfMonth);

              var querySnapshot = await FirebaseFirestore.instance
                  .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id)
                  .where("createdAt", isGreaterThanOrEqualTo: startOfMonthTimestamp)
                  .where("createdAt", isLessThanOrEqualTo: endOfMonthTimestamp)
                  .get();

              List<Sale> sales = [];

              for (var element in querySnapshot.docs) {
                Sale sale = Sale.fromDocumentSnapshot(element);
                DocumentSnapshot productSnapshot =
                    await FirebaseFirestore.instance.collection("products").doc(element["productId"]).get();
                 if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
              }

              return sales;
            }

         

            Future<List<Sale>> getThisYearSales() async {
              DateTime now = DateTime.now();
              // Calculate the start of the current year
              DateTime startOfYear = DateTime(now.year, 1, 1);
              Timestamp startOfYearTimestamp = Timestamp.fromDate(startOfYear);
              // Calculate the end of the current year
              DateTime endOfYear = DateTime(now.year + 1, 1, 0); // Last day of the current year
              Timestamp endOfYearTimestamp = Timestamp.fromDate(endOfYear);

              var querySnapshot = await FirebaseFirestore.instance
                  .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id)
                  .where("createdAt", isGreaterThanOrEqualTo: startOfYearTimestamp)
                  .where("createdAt", isLessThanOrEqualTo: endOfYearTimestamp)
                  .get();

              List<Sale> sales = [];

              for (var element in querySnapshot.docs) {
                Sale sale = Sale.fromDocumentSnapshot(element);
                DocumentSnapshot productSnapshot =
                    await FirebaseFirestore.instance.collection("products").doc(element["productId"]).get();
                 if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
              }

              return sales;
            }
              Future<List<Sale>> getInRangeSales() async {
          
             var querySnapshot;
                  if(startingDate.value != null && endingDate.value != null){
                        querySnapshot = await FirebaseFirestore.instance
                                        .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id)
                                        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(startingDate.value!))
                                        .where("createdAt", isLessThanOrEqualTo: Timestamp.fromDate(endingDate.value!))
                                        .get();
                  }
                  
              List<Sale> sales = [];
                      if(querySnapshot != null){
                      for (var element in querySnapshot.docs) {
                            Sale sale = Sale.fromDocumentSnapshot(element);
                            DocumentSnapshot productSnapshot =
                                await FirebaseFirestore.instance.collection("products").doc(element["productId"]).get();
                             if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
                          }
                      }
             print("here is results"); 
print(sales);
              return sales;
            }


            Future<List<Sale>> getAllTimeSales() async {
            

              var querySnapshot = await FirebaseFirestore.instance
                  .collection("sales").where(businessController.selectedRegister.value != null? "registerId":"businessId",isEqualTo:businessController.selectedRegister.value != null? businessController.selectedRegister.value?.id: businessController.selectedBusiness.value?.id)
                  .get();

              List<Sale> sales = [];

              for (var element in querySnapshot.docs) {
                Sale sale = Sale.fromDocumentSnapshot(element);
                DocumentSnapshot productSnapshot =
                    await FirebaseFirestore.instance.collection("products").doc(element["productId"]).get();
                 if(productSnapshot.exists){
                  sale.product = Product.fromDocumentSnapshot(productSnapshot);
                  sales.add(sale);
                 }
              }

              return sales;
            }
     double totalSales (List<Sale> sales){
      double total = 0;
      for (var sale in sales) {
        total = total +  sale.totalPrice;
      }
      return total;
     }
     double productsCapital (List<Sale> sales){
      double total = 0;
      for (var sale in sales) {
        total = total +  sale.buyingPrice;
      }
      return total;
     }
      double productsProfit (List<Sale> sales){
      return totalSales(sales)- productsCapital(sales);
     }
     Future<void> addSale ()async{
          try {
            List<Product> products = productController.onCartProducts.value;
            print(products.length);
            for (var product in products) {
              var id = Timestamp.now().toDate().toString();
              DateTime now = DateTime.now();
              var createdAt = Timestamp.fromDate(DateTime(now.year,now.month,now.day));
  

               await firestore.collection("sales").doc(id).set({
                "id":id,
                "businessId":businessController.selectedBusiness.value?.id,
                "registerId":businessController.selectedRegister.value?.id,
                "staffId":authController.user?.email,
                "productId":product.id,
                "amount":product.onCartAmount,
                "price":product.sellingPrice - product.discount,
                "buyingPrice":product.buyingPrice,                
                "totalPrice":product.onCartAmount * product.sellingPrice - product.discount,
                "description":"",
                "customerId":"",
                "discount":product.discount,
                "paid":true,
                "createdAt":createdAt
              }); 
            }
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteSale (saleId)async{
          try {
           await  firestore.collection("sales").doc(saleId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        // salesReceiver.bindStream(getSales());
          super.onInit();
        }
}