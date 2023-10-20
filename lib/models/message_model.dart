
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos/models/client.dart';

class Message{
  late String message;
  late Client client;
  late String id;
  late String name;
  late String image;
  late int readBy = 1;
  late String replyTo;
  late String from;
  late String to;
  late bool isRead;
  late String repliedMessageId;
  late Timestamp createdAt;
  late bool bookmarked = false;
  late String type= "message";

  Message();
  Message.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    id = documentSnapshot["id"];
    message = documentSnapshot["message"];
    image = documentSnapshot["image"];
    name = documentSnapshot["name"];
    from = documentSnapshot["from"];
    to = documentSnapshot["to"];
    // isRead = documentSnapshot["isRead"];
    createdAt = documentSnapshot["createdAt"];
  }
}