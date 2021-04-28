part of 'google_auth_cubit.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();
}

class GoogleAuthInitial extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthLoading extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthFailure extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthSuccess extends GoogleAuthState {
  @override
  List<Object> get props => [];
}
