import 'package:cloud_firestore/cloud_firestore.dart';

class PosterRequest{
  late String id;
  late String request;
  late String productId;
  late String posterImage;
  late bool completed = false;
  late String businessId;
  late bool useOtherImage = false;
  late Timestamp createdAt;

 PosterRequest();
 PosterRequest.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
  id = documentSnapshot["id"];
  request = documentSnapshot["request"];
  productId = documentSnapshot["productId"];
  posterImage = documentSnapshot["posterImage"];
  businessId = documentSnapshot["businessId"];
  completed = documentSnapshot["completed"];
  useOtherImage = documentSnapshot["useOtherImage"];
  createdAt = documentSnapshot["createdAt"];
 }

}