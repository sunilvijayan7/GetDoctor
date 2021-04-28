

import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class GetOneToOneSingleUserChannelIdUseCase{
  final FirebaseRepository repository;

  GetOneToOneSingleUserChannelIdUseCase({this.repository});

  Future<String> call(String uid,String otherUid) async{
    return repository.getOneToOneSingleUserChannelId(uid, otherUid);
  }
}