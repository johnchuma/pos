import 'package:cloud_firestore/cloud_firestore.dart';

class NewAttributeController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;

   Future<void> addNewAttribute () async{
          try {
           QuerySnapshot querySnapshot =await  firestore.collection("products").get();
           for (var doc in querySnapshot.docs) {
           await firestore.collection("products").doc(doc["id"]).update({"isCheap":false});      
           }
          } catch (e) {
          }
       }
}