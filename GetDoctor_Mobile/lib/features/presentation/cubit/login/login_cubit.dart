import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'package:getdoctor/features/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/google_sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_up_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;
  LoginCubit({this.signUpUseCase,this.signInUseCase,this.googleSignInUseCase,this.getCreateCurrentUserUseCase}) : super(LoginInitial());

  Future<void> signInInSubmit({String email,String password})async{
    emit(LoginLoading());
    try{
      await signInUseCase.call(email, password);
      emit(LoginSuccess());
    }on SocketException catch(_){
      emit(LoginFailure());
    }catch(_){
      emit(LoginFailure());
    }
  }
  Future<void> signUpSubmit({String email,String password,String name,String accountType})async{
    emit(LoginLoading());
    try{
      await signUpUseCase.call(email, password);
      await getCreateCurrentUserUseCase.call(UserEntity(
        email: email,
        name: name,
        accountType: accountType,
      ));
      emit(LoginSuccess());
    }on SocketException catch(_){
      emit(LoginFailure());
    }catch(_){
      emit(LoginFailure());
    }
  }

  Future<void> googleSignIn() async {
    emit(LoginLoading());
    try {
      await googleSignInUseCase.call();
      emit(LoginSuccess());
    } on SocketException catch (_) {
      emit(LoginFailure());
    } catch (_) {
      emit(LoginFailure());
    }
  }


}
