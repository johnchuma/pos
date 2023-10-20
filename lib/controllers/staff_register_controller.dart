


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/worker_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/staff.dart';
import 'package:pos/models/staff_registers.dart';



class StaffRegistersController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<StaffRegister>> staffRegistersReceiver = Rx<List<StaffRegister>>([]);
        List<StaffRegister> get staffRegisters => staffRegistersReceiver.value;
       
        StaffsController staffController = Get.find<StaffsController>();
        Rx<List<String>> selectedStaffRegisterIds = Rx<List<String>>([]);
      

        Rx<bool> showSaveButton = Rx<bool>(false);
        Rx<bool> showPassword = Rx<bool>(false);


        
        AuthController authController = Get.find<AuthController>();
        
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<StaffRegister>> getStaffRegisters() {
          return firestore
              .collection("staffRegisters").where("staffId",isEqualTo:staffController.selectedStaff.value.details.email ).where("businessId",isEqualTo: businessController.selectedBusiness.value.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<StaffRegister> staffRegisters = [];
                  for (var element in querySnapshot.docs) {
                    StaffRegister staffRegister = StaffRegister.fromDocumentSnapshot(element);
                    staffRegisters.add(staffRegister);
                }
            return staffRegisters;    
          });
        }

    
   
      Future<void> assignRegisterToStaff (registerId)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("staffRegisters").doc(id).set({
              "id":id,
              "staffId":staffController.selectedStaff.value.details.email,
              "businessId":businessController.selectedBusiness.value.id,
              "registerId":registerId,
              "permissions":[],
              "password":null,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
Future<void> updateStaffRegisterDoc (staffRegisterId, data)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("staffRegisters").doc(staffRegisterId).update(data);
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteStaffRegister (id)async{
          try {
           await  firestore.collection("staffRegisters").doc(id).delete();
          } catch (e) {
            print(e);
          }
      }
       



        @override
        void onInit() {
        staffRegistersReceiver.bindStream(getStaffRegisters());
          super.onInit();
        }
}