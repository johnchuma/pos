
// ignore_for_file: prefer_null_aware_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/notification_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/supplier.dart';
import 'package:pos/models/product_order.dart';
import 'package:pos/models/supplier_order.dart';
import 'package:pos/models/product.dart';



class SupplierOrderController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<SupplierOrder>> supplierOrdersReceiver = Rx<List<SupplierOrder>>([]);
        List<SupplierOrder> get supplierOrders => supplierOrdersReceiver.value;
          Rx<List<SupplierOrder>> completedOrdersReceiver = Rx<List<SupplierOrder>>([]);
          Rx<ProductOrder?> selectedProductOrder = Rx<ProductOrder?>(null);
          Rx<SupplierOrder?> selectedSupplierOrder = Rx<SupplierOrder?>(null);

      Rx<bool> fetching = Rx<bool>(false);
        List<SupplierOrder> get completedOrders => completedOrdersReceiver.value;
        Rx<Supplier?> selectedSupplier = Rx<Supplier?>(null);
        


          Rx<List<Product>> onCartSupplierOrders = Rx<List<Product>>([]);
      

          
          Rx<double> totalCartAmount = Rx<double>(0.0);
          Rx<String> searchKeyword= Rx<String>("");

        AuthController authController = Get.find<AuthController>();
  
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<SupplierOrder>> getSupplierOrders() {
          return firestore
              .collection("orders").
              where("supplierId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
             
              fetching.value = true;
               
               List<SupplierOrder> supplierOrders = [];
                  for (var element in querySnapshot.docs) {
                  SupplierOrder supplierOrder = SupplierOrder.fromDocumentSnapshot(element);
                  QuerySnapshot productOrdersSnapshot = await firestore.collection("orderProducts").where("supplierOrderId",isEqualTo: element["id"]).get();
                  for (var doc in productOrdersSnapshot.docs) {
                    ProductOrder productOrder = ProductOrder.fromDocumentSnapshot(doc);
                    DocumentSnapshot productSnapshot =  await firestore.collection("products").doc(productOrder.productId).get();
                    if(productSnapshot.exists){
                     productOrder.product.value = Product.fromDocumentSnapshot(productSnapshot);
                     supplierOrder.productOrders.value.add(productOrder);
                    }
                  }
                DocumentSnapshot doc = await firestore.collection("businesses").doc(element["businessId"]).get();
                  supplierOrder.from = Business.fromDocumentSnapshot(doc);
                  supplierOrder.unreadMessages.bindStream(NotificationController().getUnreadOrderMessages(supplierOrder.id));
                  supplierOrders.add(supplierOrder);
                }
              fetching.value = false;
            return supplierOrders;    
          });
        }
        Stream<List<SupplierOrder>> previousOrders() {
          return firestore
              .collection("orders").
              where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).
              where("isClosed",isEqualTo: true).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<SupplierOrder> supplierOrders = [];
                  for (var element in querySnapshot.docs) {
                  SupplierOrder supplierOrder = SupplierOrder.fromDocumentSnapshot(element);
                  QuerySnapshot productOrdersSnapshot = await firestore.collection("orderProducts").where("supplierOrderId",isEqualTo: element["id"]).get();
                  for (var doc in productOrdersSnapshot.docs) {
                    ProductOrder productOrder = ProductOrder.fromDocumentSnapshot(doc);
                    DocumentSnapshot productSnapshot =  await firestore.collection("products").doc(productOrder.productId).get();
                    if(productSnapshot.exists){
                     productOrder.product.value = Product.fromDocumentSnapshot(productSnapshot);
                     supplierOrder.productOrders.value.add(productOrder);
                    }
                  }
                  DocumentSnapshot doc = await firestore.collection("businesses").doc(element["supplierId"]).get();
                  supplierOrder.supplier = Business.fromDocumentSnapshot(doc);
                  supplierOrders.add(supplierOrder);
                }
            return supplierOrders;    
          });
        }
     Future<void> addSupplierOrder ()async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("orders").doc(id).set({
              "id":id,
              "businessId":businessController.selectedBusiness.value?.id,
              "supplierId":selectedSupplier.value == null ?null:selectedSupplier.value?.id,
              "isClosed":false,
              "inAppOrder":selectedSupplier.value == null?true:false,
              "createdAt":Timestamp.now()
            }).then((value) async{
           await addOrderProducts(id);
            });
          } catch (e) {
            print(e);
          }
      }
  Future<void> addOrderProducts (var supplierorderId)async{
          try {
            for (var product in onCartSupplierOrders.value) {
               var id = Timestamp.now().toDate().toString();
           await  firestore.collection("orderProducts").doc(id).set({
              "id":id,
              "supplierOrderId":supplierorderId,
              "productId":product.id,
              "amount":product.onCartAmount,
              "isDelivered":false,
              "createdAt":Timestamp.now()
            });
            }
           
          } catch (e) {
            print(e);
          }
      }
        Future<void> deleteSupplierOrder (supplierOrderId) async{
          try {
           await firestore.collection("orders").doc(supplierOrderId).delete();
          } catch (e) {
          }
       }
        Future<void> updateOrderProducts (orderProductId,{data}) async{
          try {
           await firestore.collection("orderProducts").doc(orderProductId).update(data);
          } catch (e) {
            print(e);
          }
       }
         Future<void> deleteOrderProduct (orderProductId) async{
          try {
           await firestore.collection("orderProducts").doc(orderProductId).delete();
          } catch (e) {
            print(e);
          }
       }
        Future<void> updateSupplierProducts (supplierOrdersId,{data}) async{
          try {
           await firestore.collection("orders").doc(supplierOrdersId).update(data);
          } catch (e) {
            print(e);
          }
       }
        @override
        void onInit() {
          supplierOrdersReceiver.bindStream(getSupplierOrders());
          completedOrdersReceiver.bindStream(previousOrders());
          super.onInit();
        }
}