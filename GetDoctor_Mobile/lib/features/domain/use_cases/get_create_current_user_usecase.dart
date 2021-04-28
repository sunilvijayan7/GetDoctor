


import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class GetCreateCurrentUserUseCase{
  final FirebaseRepository repository;

  GetCreateCurrentUserUseCase({this.repository});

  Future<void> call(UserEntity user){
    return repository.getCreateCurrentUser(user);
  }
}