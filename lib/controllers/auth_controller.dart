// ignore_for_file: empty_catches, avoid_print, body_might_complete_normally_catch_error, duplicate_ignore, unused_import

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pos/models/client.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Rx<User?> userController = Rx<User?>(null);
  Rx<Client?> me = Rx<Client?>(null);
  User? get user => userController.value;
  bool isLoading =true;
  Rx<bool> loading =Rx<bool>(false);

  GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<GoogleSignInAccount?> accountController = Rx<GoogleSignInAccount?>(null);
  GoogleSignInAccount? get userDetails => accountController.value;

  
  @override
  void onInit() {
    userController.bindStream(auth.authStateChanges());
    
    isLoading = false;
    super.onInit();
  }

  Future signIn(String email,String password) async{
    try {
    print(email);
    print(password);
    await  auth.signInWithEmailAndPassword(email:email , password: password);
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString(),backgroundColor: Colors.white);
    }
  }
Future<Client> findMyInfo()async {
    DocumentSnapshot documentSnapshot =  await firestore.collection("clients").doc(user?.email).get();
   var client = Client.fromDocumentSnapshot(documentSnapshot);
   return client;
}

Future<Client?> findUserByEmail(email)async {
    DocumentSnapshot documentSnapshot =  await firestore.collection("clients").doc(email).get();
      Client? client;
      if(documentSnapshot.exists){
        client = Client.fromDocumentSnapshot(documentSnapshot);
      }
   return client;
}

Future<void> updateClientInfo(data) async {
  try {
    await FirebaseFirestore.instance.collection('clients').doc(auth.currentUser?.email).update(data);
  } catch (e) {
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
  }
}



Future<void> registerClient() async {
  try {
    
      var googleUser = await googleSignIn.signIn();
     
       if (googleUser == null) {
      return;
          }else{
              accountController.value = googleUser;
          }
     
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("clients").doc(googleUser.email).get();
  if(documentSnapshot.exists == false){
    OneSignal.shared.setExternalUserId(googleUser.email);
  var status = await OneSignal.shared.getDeviceState();
    await FirebaseFirestore.instance.collection('clients').doc(googleUser.email).set({
      'name': googleUser.displayName,
      'address': "",
      'gender': "",
      'phone': "",
      'password':"",
      "onesignalToken":status?.userId,
      "language":"ENG",
      "selectedDashboard":"main",
      'role': "client",
      'email': googleUser.email,
      'profileImageUrl': googleUser.photoUrl,
    });
  }
  await auth.signInWithCredential(credential);

   
  } catch (e) {
    
    print(e);
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
  }
}

  Future<String> getImageLink(File file) async {
    String url = "";
    String fileName = file.path.split('/').last;  
    await storage
        .ref()
        .child("images")
        .child(fileName)
        .putFile(file)
        .catchError((error) {});
    await storage
        .ref()
        .child("images")
        .child(fileName)
        .getDownloadURL()
        .then((value) {
      url = value;
      // ignore: avoid_print, invalid_return_type_for_catch_error
    }).catchError((err) => print(err));
    return url;
  }




  void logout ()async{
    try {
      await auth.signOut();
    } catch (e) {
      
    }
  }
}