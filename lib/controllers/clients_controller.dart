


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/client.dart';


class ClientsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Client>> clientsReceiver = Rx<List<Client>>([]);
        List<Client> get clients => clientsReceiver.value;
       
        Rx<Client?> selectedClient = Rx<Client?>(null);
      
        Stream<List<Client>> getClients() {
          return firestore
              .collection("clients")
              .snapshots()
              .asyncMap((QuerySnapshot querySnapshot) async{
               List<Client> clients = [];
                  for (var element in querySnapshot.docs) {
                    Client client = Client.fromDocumentSnapshot(element);
                    clients.add(client);
                }
            return clients;    
          });
        }

    

        Future<void> deleteClient (clientId)async{
          try {
           await  firestore.collection("clients").doc(clientId).delete();
          } catch (e) {
            print(e);
          }
      }
       



        @override
        void onInit() {
        clientsReceiver.bindStream(getClients());
          super.onInit();
        }
}