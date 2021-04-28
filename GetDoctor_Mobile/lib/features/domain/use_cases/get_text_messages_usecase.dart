
import 'package:getdoctor/features/domain/entities/text_messsage_entity.dart';
import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class GetTextMessagesUseCase{
  final FirebaseRepository repository;

  GetTextMessagesUseCase({this.repository});

  Stream<List<TextMessageEntity>> call(String channelId){
    return repository.getMessages(channelId);
  }
}