
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/product_request.dart';
import 'package:pos/models/register.dart';
import 'package:pos/pages/admin/unapproved_product_requests.dart';

class ProductRequestController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<ProductRequest>> productrequestsReceiver = Rx<List<ProductRequest>>([]);
        Rx<ProductRequest?> selectedProductRequest = Rx<ProductRequest?>(null);
        AuthController authController = Get.find<AuthController>();
        Rx<Client?> selectedClient = Rx<Client?>(null);
        List<ProductRequest> get productrequests => productrequestsReceiver.value;
        BusinessController businessController = Get.find<BusinessController>();
         bool isClient = false;
         bool aboutProductRequest= false;
        int selectedStream;
        ProductRequestController({this.selectedStream = 0});
        Stream<List<ProductRequest>> getProductRequests() {
          return firestore
              .collection("productRequests").where("from",isEqualTo: authController.user?.email).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<ProductRequest> productrequests = [];
                  for (var element in querySnapshot.docs) {
                  ProductRequest productrequest = ProductRequest.fromDocumentSnapshot(element);
                  productrequest.messages.bindStream(UnreadMessagesController().getUnreadMessagesWithReference(referenceId: productrequest.id,messageType: "productRequest",to: authController.auth.currentUser?.email));
                  productrequests.add(productrequest);
                }
            return productrequests;    
          });
        }

          Stream<List<Business>> getBusinessesThatMadeOffers() {
            selectedProductRequest.value?.businessesThatSentTheirOffers.add("");
          return firestore
              .collection("businesses").where("id",whereIn:selectedProductRequest.value?.businessesThatSentTheirOffers)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Business> businesses = [];
                  for (var element in querySnapshot.docs) {
                  Business business = Business.fromDocumentSnapshot(element); 
                    business.messages.bindStream(UnreadMessagesController().getUnreadMessagesWithReferenceAndFrom(from: business.id, referenceId: selectedProductRequest.value?.id,messageType: "productRequest",to: authController.auth.currentUser?.email));
                  businesses.add(business);
                }
            return businesses;    
          });
        }
        
    Stream<List<ProductRequest>> unaprovedProductsRequests() {
          return firestore
              .collection("productRequests").where("category",isEqualTo: "").orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<ProductRequest> productrequests = [];
                  for (var element in querySnapshot.docs) {
                  ProductRequest productrequest = ProductRequest.fromDocumentSnapshot(element);
                  
                  productrequests.add(productrequest);
                }
            return productrequests;    
          });
        }
        Stream<List<ProductRequest>> getProductRequestsForBusinesses() {
          return firestore
              .collection("productRequests").where("category",isEqualTo: businessController.selectedBusiness.value?.category).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<ProductRequest> productrequests = [];
                  for (var element in querySnapshot.docs) {
                  ProductRequest productrequest = ProductRequest.fromDocumentSnapshot(element);
                  productrequest.messages.bindStream(UnreadMessagesController().getUnreadMessagesWithReference(referenceId: productrequest.id,messageType: "productRequest",to: businessController.selectedBusiness.value?.id));
                  
                  DocumentSnapshot documentSnapshot = await firestore.collection("clients").doc(productrequest.from).get();
                  productrequest.client = Client.fromDocumentSnapshot(documentSnapshot);
                  productrequests.add(productrequest);
                }
            return productrequests;    
          });
        }
        
      
     Future<void> sendRequest (request,image)async{
          try {
            var id = Timestamp.now().toDate().toString();
              var imagelink = "";
            if(image != null){
              imagelink =  await authController.getImageLink(image);
            }
           await  firestore.collection("productRequests").doc(id).set({
              "id":id,
              "request":request,
              "to":"",
              "from":authController.user?.email,
              "productId":"",
              "businessId":"",
              "image":imagelink,
              "businessesThatSentTheirOffers":[],
              "category":"",
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> deleteRequest (id)async{
          try {
           await  firestore.collection("productRequests").doc(id).delete();
          } catch (e) {
            print(e);
          }
      }

      Future<void> updateRequest ({data})async{
          try {
           await  firestore.collection("productRequests").doc(selectedProductRequest.value?.id).update(data);
          } catch (e) {
            print(e);
          }
      }
        
        @override
        void onInit() {
          print(selectedStream);
        List<Stream<List<ProductRequest>>> allStreams = [getProductRequests(),unaprovedProductsRequests(),getProductRequestsForBusinesses()];
        if(selectedStream == 3){
          selectedProductRequest.value?.businesses.bindStream(getBusinessesThatMadeOffers());
        }else{
        productrequestsReceiver.bindStream(allStreams[selectedStream]);
        }
          super.onInit();
        }
}