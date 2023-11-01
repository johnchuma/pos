
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/businesses_chat_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/models/Message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/supplier.dart';

class SuppliersConversationsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();
    BusinessController businessController = Get.find<BusinessController>();
  
        Rx<List<Supplier?>> businessesReceiver = Rx<List<Supplier?>>([]);
        List<Supplier?> get suppliers => businessesReceiver.value;
         String? userId;
        Future<void> updateAllNewConversations(messages)async{
          try {
          
               for (var message in messages.value) {
             if(businessController.selectedBusiness.value?.id != message.from ){
                 await firestore
                  .collection("private_messages").doc(message.id).update({
                    "readBy":2
                  });
              }
            }
           
          } catch (e) {
            print(e);
          }
        }
        Stream<List<Supplier>> getSuppliersConvesations() {
          return firestore
              .collection("suppliers").where("supplierId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
                  List<Supplier> suppliers = [];
                  
                  for (var element in querySnapshot.docs) {
                    Supplier supplier = Supplier.fromDocumentSnapshot(element);
                    supplier.business = await BusinessController().getBusiness(supplier.businessId);
                    supplier.supplier = await BusinessController().getBusiness(supplier.supplierId);
                    supplier.messages.bindStream(BusinessToSupplierChatController().getUnreadMessages(referenceId: element["id"]));    
                    suppliers.add(supplier);
                  }
                  return  suppliers;
          });
        }

        @override
  void onInit() {
    businessesReceiver.bindStream(getSuppliersConvesations());
    super.onInit();
  }
}