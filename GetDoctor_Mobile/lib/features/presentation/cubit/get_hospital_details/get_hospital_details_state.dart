part of 'get_hospital_details_cubit.dart';

abstract class GetHospitalDetailsState extends Equatable {
  const GetHospitalDetailsState();
}

class GetHospitalDetailsInitial extends GetHospitalDetailsState {
  @override
  List<Object> get props => [];
}

class GetHospitalDetailsLoading extends GetHospitalDetailsState {
  @override
  List<Object> get props => [];
}

class GetHospitalDetailsLoaded extends GetHospitalDetailsState {
  final List<DoctorEntity> data;

  GetHospitalDetailsLoaded({this.data});

  @override
  List<Object> get props => [data];
}
class GetHospitalDetailsFailure extends GetHospitalDetailsState {
  @override
  List<Object> get props => [];
}

