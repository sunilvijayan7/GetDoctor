part of 'my_appointment_cubit.dart';

abstract class MyAppointmentState extends Equatable {
  const MyAppointmentState();
}

class MyAppointmentInitial extends MyAppointmentState {
  @override
  List<Object> get props => [];
}
class MyAppointmentLoading extends MyAppointmentState {
  @override
  List<Object> get props => [];
}
class MyAppointmentFailure extends MyAppointmentState {
  @override
  List<Object> get props => [];
}
class MyAppointmentLoaded extends MyAppointmentState {
  final List<MyChatEntity> myAppointmentData;

  MyAppointmentLoaded({this.myAppointmentData});

  @override
  List<Object> get props => [myAppointmentData];
}