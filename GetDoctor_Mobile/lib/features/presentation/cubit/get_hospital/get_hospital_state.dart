part of 'get_hospital_cubit.dart';

abstract class GetHospitalState extends Equatable {
  const GetHospitalState();
}

class GetHospitalInitial extends GetHospitalState {
  @override
  List<Object> get props => [];
}
class GetHospitalLoading extends GetHospitalState {
  @override
  List<Object> get props => [];
}
class GetHospitalLoaded extends GetHospitalState {
  final List<HospitalEntity> hospitalData;

  GetHospitalLoaded({this.hospitalData});
  @override
  List<Object> get props => [hospitalData];
}
class GetHospitalFailure extends GetHospitalState {
  @override
  List<Object> get props => [];
}



