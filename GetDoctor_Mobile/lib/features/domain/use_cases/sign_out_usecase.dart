import 'package:getdoctor/features/domain/repositories/firebase_repository.dart';

class SignOutUseCase{
  final FirebaseRepository repository;

  SignOutUseCase({this.repository});
  Future<void> call(){
    return repository.signOut();
  }
}