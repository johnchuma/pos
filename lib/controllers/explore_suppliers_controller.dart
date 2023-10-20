
// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/business_subscription_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/business_subscription.dart';
import 'package:pos/models/register.dart';
import 'package:pos/models/staff_registers.dart';
import 'package:pos/models/supplier.dart';

class ExploreSuppliersController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Business>> businessesReceiver = Rx<List<Business>>([]);
        List<Business> get businesses => businessesReceiver.value;
        Rx<bool?> canAccessRegister = Rx<bool?>(false);
          Rx<List<Business>> staffBusinessesReceiver = Rx<List<Business>>([]);
        List<Business> get staffBusinesses => staffBusinessesReceiver.value;
        AppController appController= Get.find<AppController>();
        Rx<Business> selectedBusiness = Rx<Business>(Business());
        AuthController authController = Get.find<AuthController>();
        Rx<Register?> selectedRegister = Rx<Register?>(null);
      BusinessController businessController =Get.find<BusinessController>();

        Rx<String> role = Rx<String>("reseller");
        Rx<String> category = Rx<String>("");


      Future<List<Business>> findSuppliersRelatedToMyStore() async{
        List<Supplier> mySuppliers = await SupplierController().findMySuppliers();
        var array = [""];
         array.addAll(mySuppliers.map((item) => item.supplier.id));
        QuerySnapshot querySnapshot =  await firestore
              .collection("businesses").where("role",isEqualTo: "supplier").where("id",whereNotIn:array ).where("category",isEqualTo:businessController.selectedBusiness.value.category).get();
               List<Business> businesses = [];
                   for (var element in querySnapshot.docs) {
                    QuerySnapshot businesssubscriptionSnapshots = await firestore.collection("businessSubscription").where("businessId",isEqualTo: element["id"]).get();
                  List<BusinessSubscription> businessSubscriptions = [];
                  for (var subscriptionDoc in businesssubscriptionSnapshots.docs) {
                    businessSubscriptions.add(BusinessSubscription.fromDocumentSnapshot(subscriptionDoc));
                  }
                  Business business = Business.fromDocumentSnapshot(element);
                  business.businesSubscriptions = businessSubscriptions;
                  businesses.add(business);
                }
            return businesses;   
     
        }

        Future<List<Register>> getStaffRegisters() async{
         QuerySnapshot querySnapshot =await firestore
              .collection("staffRegisters").where("staffId",isEqualTo: authController.user?.email).where("businessId",isEqualTo: selectedBusiness.value.id)
              .get();
                List<Register> registers = [];
                  for (var element in querySnapshot.docs) {
                    DocumentSnapshot documentSnapshot = await firestore.collection("registers").doc(element["registerId"]).get();
                    Register register = Register.fromDocumentSnapshot(documentSnapshot);
                    registers.add(register);
                }
           return registers;
        }
    Future<int> calculateRemainedSubscriptionDays({Business? business})async{
      int days= 0;
      List<BusinessSubscription> historyList = await BusinessSubscriptionController().getSubscriptionHistory(businessId: business?.id); 
      for (var history in historyList) {
        days = days + int.parse((history.amount/10000).toString());
      }
      Business requiredBusiness = business??selectedBusiness.value; 
      DateTime firstTime =  requiredBusiness.createdAt.toDate();
      Duration difference  = firstTime.add(Duration(days: days+30)).difference(DateTime.now()); 
      return difference.inDays;
    }
    

      @override
      void onInit() {
      
     
      
      
        super.onInit();
      }
}