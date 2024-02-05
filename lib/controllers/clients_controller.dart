


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/client.dart';


class ClientsController extends GetxController{
       FirebaseFirestore firestore = FirebaseFirestore.instance;
        Rx<List<Client>> clientsReceiver = Rx<List<Client>>([]);
        List<Client> get clients => clientsReceiver.value;
         Rx<String> searchKeyword = "".obs;
        Rx<Client?> selectedClient = Rx<Client?>(null);
        Rx<Client?> selectedStaff = Rx<Client?>(null);
        
       Future<Client> getClient(id)async{
              DocumentSnapshot documentSnapshot = await firestore.collection("clients").doc(id).get();
             return Client.fromDocumentSnapshot(documentSnapshot);
        }
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