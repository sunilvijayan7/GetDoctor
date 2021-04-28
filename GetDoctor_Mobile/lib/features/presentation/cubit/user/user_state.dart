part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<UserEntity> data;

  UserLoaded({this.data});

  @override
  List<Object> get props => [data];
}

class UserSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}
