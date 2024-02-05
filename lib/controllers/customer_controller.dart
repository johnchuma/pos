
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/customer.dart';

class CustomerController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Customer>> customersReceiver = Rx<List<Customer>>([]);
        List<Customer> get customers => customersReceiver.value;
        AuthController authController = Get.find<AuthController>();
        Rx<String> searchKeyword = "".obs;
        Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Customer>> getCustomers() {
          return firestore
              .collection("customers").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async {
               List<Customer> customers = [];
                  for (var element in querySnapshot.docs) {
                  Customer customer = Customer.fromDocumentSnapshot(element);
                  customers.add(customer);
                }
                  return customers;    
          });
        }


     Future<void> addCustomer (data)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("customers").doc(id).set({
              "id":id,
              ...data,
              "businessId":businessController.selectedBusiness.value?.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }


        Future<void> updateCustomer (customerId,data)async{
          try {
           await  firestore.collection("customers").doc(customerId).update(data);
          } catch (e) {
            print(e);
          }
      }
        Future<void> deleteCustomer (customerId)async{
          try {
           await  firestore.collection("customers").doc(customerId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        customersReceiver.bindStream(getCustomers());
          super.onInit();
        }
}