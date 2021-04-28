import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class CreateOneToOneChatChannelUseCase {
  final FirebaseRepository repository;

  CreateOneToOneChatChannelUseCase({this.repository});

  Future<void> call(String uid,String otherUid)async{
    return repository.createOneToOneChatChannel(uid, otherUid);
  }
}
