
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/register.dart';

class RegisterController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Register>> registersReceiver = Rx<List<Register>>([]);
        List<Register> get registers => registersReceiver.value;
        AuthController authController = Get.find<AuthController>();
        Register? selectedRegister = null;
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Register>> getRegisters() {
          return firestore
              .collection("registers").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Register> registers = [];
                  for (var element in querySnapshot.docs) {
                  Register register = Register.fromDocumentSnapshot(element);
                  registers.add(register);
                }
            return registers;    
          });
        }


     Future<void> addRegister (name,description,{String? businessId})async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("registers").doc(id).set({
              "id":id,
              "title":name,
              "businessId": businessId?? businessController.selectedBusiness.value?.id,
              "description":description,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> updateRegister (registerId,data)async{
          try {
           await  firestore.collection("registers").doc(registerId).update(data);
          } catch (e) {
            print(e);
          }
      }
        Future<void> deleteRegister (registerId)async{
          try {
           await  firestore.collection("registers").doc(registerId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        registersReceiver.bindStream(getRegisters());
          super.onInit();
        }
}