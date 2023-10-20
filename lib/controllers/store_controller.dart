
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/store.dart';

class StoreController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Store>> storesReceiver = Rx<List<Store>>([]);
        List<Store> get stores => storesReceiver.value;
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Store>> getStores() {
          return firestore
              .collection("storesTypes")
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Store> stores = [];
                  for (var element in querySnapshot.docs) {
                  Store store = Store.fromDocumentSnapshot(element);
                  stores.add(store);
                }
            return stores;    
          });
        }


  
       
        @override
        void onInit() {
        storesReceiver.bindStream(getStores());
          super.onInit();
        }
}