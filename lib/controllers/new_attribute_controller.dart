import 'package:cloud_firestore/cloud_firestore.dart';

class NewAttributeController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;

   Future<void> addNewAttribute () async{
          try {
           QuerySnapshot querySnapshot =await  firestore.collection("businesses").get();
           for (var doc in querySnapshot.docs) {
           await firestore.collection("businesses").doc(doc["id"]).update({"isSampleBusiness":false});      
           }
          } catch (e) {
          }
       }
}