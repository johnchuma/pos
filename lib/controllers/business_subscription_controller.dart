
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/business_subscription.dart';


class BusinessSubscriptionController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Business>> businessesReceiver = Rx<List<Business>>([]);
        List<Business> get businesses => businessesReceiver.value;
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Rx<Business?> selectedBusiness = Rx<Business?>(null);
        Rx<double> subscriptionAmount = Rx<double>(10000.0);
        
        Stream<List<Business>> getBusinessSubscriptions() {
          return firestore
              .collection("businesses").where("userId",isEqualTo: authController.user?.email)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Business> businesses = [];
                  for (var element in querySnapshot.docs) {
                    QuerySnapshot businesssubscriptionSnapshots = await firestore.collection("businessSubscriptions").where("businessId",isEqualTo: element["id"]).get();
                  List<BusinessSubscription> businessSubscriptions = [];
                  for (var subscriptionDoc in businesssubscriptionSnapshots.docs) {
                    businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscriptionDoc));
                  }
                  Business business = Business.fromDocumentSnapshot(element);
                  business.businesSubscriptions = businessSubscriptions;
                  businesses.add(business);
                }
            return businesses;    
          });
        }
        Future<List<BusinessSubscription>> getSubscriptionHistory({businessId})async{
          print(businessId);
        QuerySnapshot querySnapshot = await firestore.collection("businessSubscription").where("businessId",isEqualTo: businessId?? businessController.selectedBusiness.value?.id).get();
         List<BusinessSubscription> businessSubscriptions = [];
         for (var subscription in querySnapshot.docs) {
           businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscription));
         }

         return businessSubscriptions;
        }


     Future<void> addBusinessSubscription ()async{
          try {
            var id = Timestamp.now().toDate().toString();
            int days = subscriptionAmount.value*30~/10000;
           await  firestore.collection("businessSubscriptions").doc(id).set({
              "businessId":selectedBusiness.value?.id,
              "amount":subscriptionAmount.value,
              "expiresAt":Timestamp.fromDate(DateTime.now().add(Duration(days: days))),
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteBusinessSubscription (businesssubscriptionId)async{
          try {
           await  firestore.collection("businesSubscriptions").doc(businesssubscriptionId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        businessesReceiver.bindStream(getBusinessSubscriptions());
          super.onInit();
        }
}