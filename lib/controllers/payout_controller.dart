
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/controllers/sell_controller.dart';
import 'package:pos/models/payout.dart';

class PayoutController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Payout>> payoutsReceiver = Rx<List<Payout>>([]);
        List<Payout> get payouts => payoutsReceiver.value;
        AuthController authController = Get.find<AuthController>();
        Payout? selectedPayout = null;
        Rx<String> searchKeyword = "".obs;
        BusinessController businessController = Get.find<BusinessController>();
        CustomerController  customerController = Get.find<CustomerController>();
        Stream<List<Payout>> getPayouts() {
          return firestore
              .collection("payouts").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Payout> payouts = [];
                  for (var element in querySnapshot.docs) {
                    Payout payout = Payout.fromDocumentSnapshot(element);
                    payouts.add(payout);
                }
            return payouts;    
          });
        }


      Future<void> addPayout (saleId)async{
        SellController sellController = Get.find<SellController>();
            try {
              var id = Timestamp.now().toDate().toString();
              await  firestore.collection("payouts").doc(id).set({
                "id":id,
                "customerId":customerController.selectedCustomer.value?.id,
                "name":customerController.selectedCustomer.value?.name,
                "productsId":sellController.onCartProducts.value.map((data) => data.id),
                "price":sellController.totalCartAmount.value,
                "businessId":businessController.selectedBusiness.value?.id,
                "payments":[],
                "isPaid":false,
                "saleId":saleId,
                "createdAt":Timestamp.now()
              });
            } catch (e) {
              print(e);
            }
        }
        
        Future<void> updatePayout (payoutId,data)async{
          try {
           await  firestore.collection("payouts").doc(payoutId).update(data);
          } catch (e) {
            print(e);
          }
      }
        Future<void> deletePayout (payoutId)async{
          try {
           await  firestore.collection("payouts").doc(payoutId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        payoutsReceiver.bindStream(getPayouts());
          super.onInit();
        }
}