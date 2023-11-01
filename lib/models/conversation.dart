import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:pos/models/business.dart';
import 'package:pos/models/client.dart';
import 'package:pos/models/message_model.dart';

class Conversation{
  late String id;
  late String from;
  late String to;
  late Client? client = null;
  late Business? business = null;
  late String type;
  late Timestamp createdAt;
  late Rx<List<Message>> unreadMessages = Rx<List<Message>>([]);

  Conversation();
  Conversation.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    from = documentSnapshot["from"];
    to = documentSnapshot["to"];
    type = documentSnapshot["type"];
    createdAt = documentSnapshot["createdAt"];


  }
}