
// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/business_subscription.dart';
import 'package:pos/models/register.dart';
import 'package:pos/models/staff_registers.dart';

class BusinessController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Business>> businessesReceiver = Rx<List<Business>>([]);
        List<Business> get businesses => businessesReceiver.value;
        Rx<bool?> canAccessRegister = Rx<bool?>(false);
          Rx<List<Business>> staffBusinessesReceiver = Rx<List<Business>>([]);
        List<Business> get staffBusinesses => staffBusinessesReceiver.value;
        AppController appController= Get.find<AppController>();
        Rx<Business?> selectedBusiness = Rx<Business?>(null);
        Rx<Business?> selectedSupplier = Rx<Business?>(null);

        Rx<Business> selectedSender = Rx<Business>(Business());
        AuthController authController = Get.find<AuthController>();
        Rx<Register?> selectedRegister = Rx<Register?>(null);
        Rx<String> role = Rx<String>("reseller");
        Rx<String> category = Rx<String>("");
        Rx<bool> noAccess= Rx<bool>(false);

        Stream<List<Business>> getBusinesses() {
          return firestore
              .collection("businesses").where("userId",isEqualTo: authController.user?.email).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Business> businesses = [];
                   for (var element in querySnapshot.docs) {
                    QuerySnapshot businesssubscriptionSnapshots = await firestore.collection("businessSubscription").where("businessId",isEqualTo: element["id"]).get();
                  List<BusinessSubscription> businessSubscriptions = [];
                  for (var subscriptionDoc in businesssubscriptionSnapshots.docs) {
                    businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscriptionDoc));
                  }
                  Business business = Business.fromDocumentSnapshot(element);
                  firestore.collection("staffs").where("businessId",isEqualTo:business.id ).get().then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                       ClientsController().getClient(doc["workerId"]).then((value) => {
                              business.staffs.add(value)
                      });
                    }
                  });
                  business.businesSubscriptions = businessSubscriptions;
                  businesses.add(business);
                }
            return businesses;    
          });
        }

        Future<List<Register>> getStaffRegisters() async{
          print("Running this");
          print(selectedBusiness.value?.id);
         QuerySnapshot querySnapshot =await firestore
              .collection("staffRegisters").where("staffId",isEqualTo: authController.user?.email).where("businessId",isEqualTo: selectedBusiness.value?.id)
              .get();
                List<Register> registers = [];
                  for (var element in querySnapshot.docs) {
                    DocumentSnapshot documentSnapshot = await firestore.collection("registers").doc(element["registerId"]).get();
                  Register register = Register.fromDocumentSnapshot(documentSnapshot);
                  registers.add(register);
                }
                print("Finished running");
           return registers;
        }
    Future<int> calculateRemainedSubscriptionDays({Business? business})async{
      int days= 0;
      List<BusinessSubscription> historyList = await BusinessSubscriptionController().getSubscriptionHistory(businessId: business?.id); 
      for (var history in historyList) {
        days = days + int.parse((history.amount/10000).toString());
      }
      Business requiredBusiness = business??selectedBusiness.value!; 
      DateTime firstTime =  requiredBusiness.createdAt.toDate();
      Duration difference  = firstTime.add(Duration(days: days+10)).difference(DateTime.now()); 
      return difference.inDays;
    }
     Future<StaffRegister?> getStaffRegister() async{
  List<Register> registers =    await getStaffRegisters();
    print(registers.length);
       if(registers.isNotEmpty){
        print("Is not empty");
        if(selectedRegister.value == null){
              selectedRegister.value = registers.first;
          }
        }
         QuerySnapshot querySnapshot =await firestore
              .collection("staffRegisters").where("staffId",isEqualTo: authController.user?.email).where("registerId",isEqualTo: selectedRegister.value?.id)
              .get();
              StaffRegister? staffRegister;
                if(querySnapshot.docs.isNotEmpty){
                  staffRegister = StaffRegister.fromDocumentSnapshot(querySnapshot.docs.first);
                }
            return staffRegister;   
        }
         Future<Business> getBusiness(id)async{
                  DocumentSnapshot documentSnapshot = await firestore.collection("businesses").doc(id).get();
            Business business = Business.fromDocumentSnapshot(documentSnapshot);
             firestore.collection("staffs").where("businessId",isEqualTo:business.id ).get().then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                       ClientsController().getClient(doc["workerId"]).then((value) => {
                              business.staffs.add(value)
                      });
                    }
                  });
            return business;
        }
          Future<List<Business>> getUserBusinesses()async{
        ClientsController clientsController = Get.find<ClientsController>();

                  QuerySnapshot querySnapshot = await firestore.collection("businesses").where("userId",isEqualTo:clientsController.selectedClient.value?.id).get();
          List<Business> businesses = [];
            for (var documentSnapshot in querySnapshot.docs) {
              businesses.add(Business.fromDocumentSnapshot(documentSnapshot));
            }
            return businesses;
        }


          Stream<List<Business>> getStaffBusinesses() {
          return firestore
              .collection("staffs").where("workerId",isEqualTo: authController.user?.email)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Business> businesses = [];
                  for (var element in querySnapshot.docs) {
                  DocumentSnapshot documentSnapshot = await firestore.collection("businesses").doc(element["businessId"]).get();
                  QuerySnapshot staffRegisterSnapshots = await firestore.collection("staffRegisters").where("staffId",isEqualTo:authController.user?.email).get();
                  List<StaffRegister> staffRegisters = [];
                  if(documentSnapshot.exists){
                  Business business = Business.fromDocumentSnapshot(documentSnapshot);
                  for (var staffRegisterSnapshot in staffRegisterSnapshots.docs) {
                    StaffRegister staffRegister = StaffRegister.fromDocumentSnapshot(staffRegisterSnapshot);
                    DocumentSnapshot registerSnapshot =  await firestore.collection("registers").doc(staffRegister.registerId).get();
                    staffRegister.register = Register.fromDocumentSnapshot(registerSnapshot);
                    staffRegisters.add(staffRegister);
                  }    
                  business.staffRegisters = staffRegisters;          
                  businesses.add(business);
                  }
                 
                }
            return businesses;    
          });
        }

     Future<void> createBusiness (name,phone,description,imageFile)async{
          try {
            var id = Timestamp.now().toDate().toString();
             var imagelink =  await authController.getImageLink(imageFile);
           await  firestore.collection("businesses").doc(id).set({
              "id":id,
              "name":name,
              "description":description,
              "image":imagelink,
              "phone":phone,
              "category":category.value,
              "role":role.value,
              "address":"",
              "latitude":0.0,
              "longitude":0.0,
              "userId":authController.user?.email,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
          }
      }

      Future<void> deleteBusiness (businessId) async{
          try {
           await  firestore.collection("businesses").doc(businessId).delete();
           await ProductController().deleteBusinessProducts(businessId: businessId);
          } catch (e) {
          }
      }
       Future<void> updateBusiness ({data}) async{
          try {
           await  firestore.collection("businesses").doc(selectedBusiness.value?.id).update(data);
          } catch (e) {
          }
      }
      @override
      void onInit() {
      
      businessesReceiver.bindStream(getBusinesses());
      
      staffBusinessesReceiver.bindStream(getStaffBusinesses());
      
        super.onInit();
      }
}