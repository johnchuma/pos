
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/supplier_controller.dart';
import 'package:pos/models/Message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:pos/models/business.dart';

class SuppliersConversationsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthController authContoller = Get.find<AuthController>();
    ClientsController clientController = Get.find<ClientsController>();
    AppController appController = Get.find<AppController>();
    BusinessController businessController = Get.find<BusinessController>();
  
        Rx<List<Business?>> businessesReceiver = Rx<List<Business?>>([]);
        List<Business?> get suppliers => businessesReceiver.value;
         String? userId;
        Future<void> updateAllNewConversations(Business business)async{
          try {
          
               for (var message in business.messages.value) {
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
        Stream<List<Business>> getSuppliersConvesations() {
          return firestore
              .collection("suppliers").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots() 
              .asyncMap((QuerySnapshot querySnapshot) async {
                  List<Business> businesses = [];
                  for (var element in querySnapshot.docs) {
                  DocumentSnapshot businessSnapshot = await firestore.collection("businesses").doc(element["supplierId"]).get();
                  Business business = Business.fromDocumentSnapshot(businessSnapshot);
                  var ids = [];
                  ids.add(businessController.selectedBusiness.value?.id);
                  ids.add(element["supplierId"]);
                  ids.sort();
                    Stream<List<Message>> getMessages (){
                      return firestore
                    .collection("private_messages")
                    .where("chatMembers", isEqualTo: ids)
                    .where("from", isNotEqualTo: businessController.selectedBusiness.value?.id)
                    .where("referenceId",isEqualTo: "")
                    .where("readBy", isEqualTo: 1)
                    .snapshots().map((QuerySnapshot messagesSnapshot)  {
                      List<Message> messages = [];
                       for (var doc in messagesSnapshot.docs) {
                        Message message = Message.fromDocumentSnapshot(doc);
                        messages.add(message);
                      }
                      return messages;
                    });
                      
                      } 
                    
                  business.messages.bindStream(getMessages());    
                    businesses.add(business);
                  }
                  return  businesses;
          });
        }

        @override
  void onInit() {
    businessesReceiver.bindStream(getSuppliersConvesations());
    super.onInit();
  }
}