
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/attendance.dart';

class AttendanceController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Attendance>> attendancesReceiver = Rx<List<Attendance>>([]);
        List<Attendance> get attendances => attendancesReceiver.value;
        AuthController authController = Get.find<AuthController>();
        BusinessController businessController = Get.find<BusinessController>();
        Stream<List<Attendance>> getAttendances() {
          return firestore
              .collection("attendances").where("businessId",isEqualTo: businessController.selectedBusiness.value?.id).orderBy("createdAt",descending: true)
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Attendance> attendances = [];
                  for (var element in querySnapshot.docs) {
                  Attendance attendance = Attendance.fromDocumentSnapshot(element);
                  attendances.add(attendance);
                }
            return attendances;    
          });
        }


     Future<void> checkIn ()async{
          try {
            var id = Timestamp.now().toDate().toString();
           await  firestore.collection("attendances").doc(id).set({
              "id":id,
              "staffId":authController.auth.currentUser?.email,
              "businessId":businessController.selectedBusiness.value?.id,
              "checkInTime":Timestamp.now(),
              "checkOutTime":null,
              "createdAt":Timestamp.now()
            });
          } catch (e) {
            print(e);
          }
      }
       Future<void> checkOut (attendanceId)async{
          try {
         
           await  firestore.collection("attendances").doc(attendanceId).update({
            "checkOutTime":Timestamp.now()
           });
          } catch (e) {
            print(e);
          }
      }


        Future<void> deleteAttendance (attendanceId)async{
          try {
           await  firestore.collection("attendances").doc(attendanceId).delete();
          } catch (e) {
            print(e);
          }
      }
       
        @override
        void onInit() {
        attendancesReceiver.bindStream(getAttendances());
          super.onInit();
        }
}