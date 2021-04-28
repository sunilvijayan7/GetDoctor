
import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class UpdateSingleMessageUseCase{
  final FirebaseRepository repository;

  UpdateSingleMessageUseCase({this.repository});

  Future<void> call(String channelId,String messageId,bool isOPD){
    return repository.updateSingleMessage(channelId, messageId, isOPD);
  }
}