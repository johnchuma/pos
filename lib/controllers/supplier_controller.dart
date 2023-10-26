
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';

import 'package:pos/models/supplier.dart';
import 'package:pos/models/business.dart';

class SupplierController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Supplier>> suppliersReceiver = Rx<List<Supplier>>([]);
        List<Supplier> get suppliers => suppliersReceiver.value;
        Rx<Supplier> selectedSupplier = Rx<Supplier>(Supplier());
        AuthController authController = Get.find<AuthController>();
  
        BusinessController businessController = Get.find<BusinessController>();
      
        Stream<List<Supplier>> getSuppliers() {
          return firestore
              .collection("suppliers").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Supplier> suppliers = [];
                  for (var element in querySnapshot.docs) {
                DocumentSnapshot documentSnapshot =   await firestore.collection("businesses").doc(element["supplierId"]).get();
              if(documentSnapshot.exists){
                 Supplier supplier = Supplier.fromDocumentSnapshot(element);
                 supplier.supplier = Business.fromDocumentSnapshot(documentSnapshot);
                 suppliers.add(supplier);
              }
                }
            return suppliers;    
          });
        }
     
      Future<List<Supplier>> findMySuppliers() async{
       QuerySnapshot querySnapshot =await    firestore
              .collection("suppliers").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .get();
         List<Supplier> suppliers = [];
                  for (var element in querySnapshot.docs) {
                DocumentSnapshot documentSnapshot =   await firestore.collection("businesses").doc(element["supplierId"]).get();
              if(documentSnapshot.exists){
                 Supplier supplier = Supplier.fromDocumentSnapshot(element);
                 supplier.supplier = Business.fromDocumentSnapshot(documentSnapshot);
                 suppliers.add(supplier);
              }
          }
            return suppliers; 
        }
     Future<void> addSupplier (supplierId)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("suppliers").doc(id).set({
              "id":id,
              "supplierId":supplierId,
              "businessId":businessController.selectedBusiness.value?.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteSupplier (supplierId)async{
          try {
           await  firestore.collection("suppliers").doc(supplierId).delete();
          } catch (e) {
            print(e);
          }
      }
       



        @override
        void onInit() {
        suppliersReceiver.bindStream(getSuppliers());
          super.onInit();
        }
}