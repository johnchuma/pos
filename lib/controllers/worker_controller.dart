


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/staff.dart';


class StaffsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Staff>> staffsReceiver = Rx<List<Staff>>([]);
        List<Staff> get staffs => staffsReceiver.value;
       
        Rx<Staff> selectedStaff = Rx<Staff>(Staff());
        AuthController authController = Get.find<AuthController>();
        
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Staff>> getStaffs() {
          return firestore
              .collection("staffs").where("businessId",isEqualTo: businessController.selectedBusiness.value.id)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Staff> staffs = [];
                  for (var element in querySnapshot.docs) {
                    Staff staff = Staff.fromDocumentSnapshot(element);
                    DocumentSnapshot documentSnapshot = await firestore.collection("clients").doc(element["workerId"]).get();
                    
                    if(documentSnapshot.exists){
                    staff.details = Client.fromDocumentSnapshot(documentSnapshot);
                    staffs.add(staff);
                    }
                   
                }
            return staffs;    
          });
        }

     Future<void> addWorker (email)async{
          try {
            
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("staffs").doc(id).set({
              "id":id,
              "workerId":email,
              "businessId":businessController.selectedBusiness.value.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
   
      Future<void> assignRegisterToStaff (registerId)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("staffRegisters").doc(id).set({
              "id":id,
              "workerId":selectedStaff.value.details.email,
              "registerId":registerId,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }


        Future<void> deleteStaff (staffId)async{
          try {
           await  firestore.collection("staffs").doc(staffId).delete();
          } catch (e) {
            print(e);
          }
      }
       



        @override
        void onInit() {
        staffsReceiver.bindStream(getStaffs());
          super.onInit();
        }
}