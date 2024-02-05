
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/business_subscription.dart';


class BusinessSubscriptionController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<BusinessSubscription>> businessesSubscriptionReceiver = Rx<List<BusinessSubscription>>([]);
        List<BusinessSubscription> get businessesSubscriptions => businessesSubscriptionReceiver.value;
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Rx<Business?> selectedBusiness = Rx<Business?>(null);
        Rx<double> subscriptionAmount = Rx<double>(10000.0);
        
    
        Stream<List<BusinessSubscription>> getBusinessSubscriptions() {
          return firestore
              .collection("businessSubscriptions").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async {
                List<BusinessSubscription> businessSubscriptions = [];
                for (var element in querySnapshot.docs) {
                 BusinessSubscription businessSubscription = BusinessSubscription.fromDocumentSnapshot(element);
                 businessSubscriptions.add(businessSubscription);
                }
                return businessSubscriptions;    
          });
        }


        Future<List<BusinessSubscription>> getSubscriptionHistory({businessId})async{
          print(businessId);
        QuerySnapshot querySnapshot = await firestore.collection("businessSubscriptions").where("businessId",isEqualTo: businessId?? businessController.selectedBusiness.value?.id).get();
         List<BusinessSubscription> businessSubscriptions = [];
         for (var subscription in querySnapshot.docs) {
           businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscription));
         }
         return businessSubscriptions;
        }


     Future<int> checkRemainedDays()async{
        QuerySnapshot querySnapshot = await firestore.collection("businessSubscriptions")
        .where("businessId",isEqualTo:businessController.selectedBusiness.value?.id).get();
         List<BusinessSubscription> businessSubscriptions = [];
         for (var subscription in querySnapshot.docs) {
           businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscription));
         }
         int days = 0;
         print(days);
         businessSubscriptions.forEach((element) {
            days = element.remainedDays()+days;
          });
         return days;
        }


     Future<void> addBusinessSubscription (amount)async{
          try {
            var id = Timestamp.now().toDate().toString();
            int days = amount*30~/15000;
           await  firestore.collection("businessSubscriptions").doc(id).set({
              "businessId":businessController.selectedBusiness.value?.id,
              "amount":amount,
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
         businessesSubscriptionReceiver.bindStream(getBusinessSubscriptions());
          super.onInit();
        }
}