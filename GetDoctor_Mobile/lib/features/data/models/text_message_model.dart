import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:getdoctor/features/domain/entities/text_messsage_entity.dart';

class TextMessageModel extends TextMessageEntity {
  TextMessageModel(
      {   String senderName,
        String sederUID,
        String recipientName,
        String recipientUID,
        String messageType,
        String message,
        bool isOdp,
        String messageId,
        Timestamp time,}
      ) : super(
    senderName:senderName,
    sederUID: sederUID,
    recipientName: recipientName,
    recipientUID: recipientUID,
    messsageType:messageType,
    message:message,
    isOdp:isOdp,
    messageId:messageId,
    time: time,
  );
  factory TextMessageModel.fromSnapShot(DocumentSnapshot snapshot){
    return TextMessageModel(
      senderName: snapshot.data()['senderName'],
      sederUID: snapshot.data()['sederUID'],
      recipientName: snapshot.data()['recipientName'],
      recipientUID: snapshot.data()['recipientUID'],
      messageType: snapshot.data()['messageType'],
      message: snapshot.data()['message'],
      isOdp: snapshot.data()['isOdp'],
      messageId: snapshot.data()['messageId'],
      time: snapshot.data()['time'],
    );
  }
  Map<String,dynamic> toDocument(){
    return {
      "senderName":senderName,
      "sederUID":sederUID,
      "recipientName":recipientName,
      "recipientUID":recipientUID,
      "messageType":messsageType,
      "message":message,
      "isOdp":isOdp,
      "messageId":messageId,
      "time":time,
    };
  }
}