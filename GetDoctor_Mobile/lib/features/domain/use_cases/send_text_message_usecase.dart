

import 'package:getdoctor/features/domain/entities/text_messsage_entity.dart';
import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class SendTextMessageUseCase{
  final FirebaseRepository repository;

  SendTextMessageUseCase({this.repository});

  Future<void> call(TextMessageEntity textMessageEntity,String channelId)async{
    return await repository.sendTextMessage(textMessageEntity,channelId);
  }
}