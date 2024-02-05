
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/product_controller.dart';
import 'package:pos/models/poster_request.dart';


class PosterRequestController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<PosterRequest>> posterrequestsReceiver = Rx<List<PosterRequest>>([]);
        List<PosterRequest> get posterrequests => posterrequestsReceiver.value;
        
        AuthController authController = Get.find<AuthController>();
        PosterRequest? selectedPosterRequest = null;
        BusinessController businessController = Get.find<BusinessController>();
        ProductController productController = Get.find<ProductController>();
        Stream<List<PosterRequest>> getPosterRequests() {
          return firestore
              .collection("posterRequests").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<PosterRequest> posterrequests = [];
                  for (var element in querySnapshot.docs) {
                  PosterRequest posterrequest = PosterRequest.fromDocumentSnapshot(element);
                  posterrequests.add(posterrequest);
                }
            return posterrequests;    
          });
        }
 

     Future<void> addPosterRequest (request,useOtherImage)async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("posterRequests").doc(id).set({
              "id":id,
              "productId":productController.selectedProduct.value.id,
              "posterImage":"",
              "request":request,
              "completed":false,
              "useOtherImage":useOtherImage,
              "businessId":businessController.selectedBusiness.value?.id,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }

        Future<void> updatePosterRequest (posterrequestId,data)async{
          try {
           await  firestore.collection("posterRequests").doc(posterrequestId).update(data);
          } catch (e) {
            print(e);
          }
      }
        Future<void> deletePosterRequest (posterrequestId)async{
          try {
           await  firestore.collection("posterRequests").doc(posterrequestId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        posterrequestsReceiver.bindStream(getPosterRequests());
          super.onInit();
        }
}