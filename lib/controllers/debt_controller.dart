
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/customer_controller.dart';
import 'package:pos/controllers/sell_controller.dart';
import 'package:pos/models/debt.dart';

class DebtController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Debt>> debtsReceiver = Rx<List<Debt>>([]);
        List<Debt> get debts => debtsReceiver.value;
        AuthController authController = Get.find<AuthController>();
        Debt? selectedDebt = null;
        Rx<String> searchKeyword = "".obs;
        BusinessController businessController = Get.find<BusinessController>();
        CustomerController  customerController = Get.find<CustomerController>();
      
        Stream<List<Debt>> getDebts() {
          return firestore
              .collection("debts").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Debt> debts = [];
                  for (var element in querySnapshot.docs) {
                  Debt debt = Debt.fromDocumentSnapshot(element);
                  debts.add(debt);
                }
            return debts;    
          });
        }


     Future<void> addDebt (saleId)async{
        SellController sellController = Get.find<SellController>();
          try {
            var id = Timestamp.now().toDate().toString();
            await  firestore.collection("debts").doc(id).set({
              "id":id,
              "customerId":customerController.selectedCustomer.value?.id,
              "name":customerController.selectedCustomer.value?.name,
              "saleId":saleId,
              "productsId":sellController.onCartProducts.value.map((data) => data.id),
              "price":sellController.totalCartAmount.value,
              "businessId":businessController.selectedBusiness.value?.id,
              "payments":[],
              "isPaid":false,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
      

        Future<void> updateDebt (debtId,data)async{
          try {
           await  firestore.collection("debts").doc(debtId).update(data);
          } catch (e) {
            print(e);
          }
      }
        Future<void> deleteDebt (debtId)async{
          try {
           await  firestore.collection("debts").doc(debtId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        debtsReceiver.bindStream(getDebts());
          super.onInit();
        }
}