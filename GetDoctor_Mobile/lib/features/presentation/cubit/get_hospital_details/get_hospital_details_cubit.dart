import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:getdoctor/features/domain/entities/doctor_entity.dart';
import 'package:getdoctor/features/domain/use_cases/get_hospital_details.dart';

part 'get_hospital_details_state.dart';

class GetHospitalDetailsCubit extends Cubit<GetHospitalDetailsState> {
  final GetHospitalDetailsUseCase getHospitalDetailsUseCase;
  GetHospitalDetailsCubit({this.getHospitalDetailsUseCase}) : super(GetHospitalDetailsInitial());

  Future<void> getHospitalDetails({String hospitalId})async{

    try{
      final streamResponse=getHospitalDetailsUseCase.call(hospitalId);
      streamResponse.listen((event) {
        emit(GetHospitalDetailsLoaded(
          data: event
        ));
      });
    }on SocketException catch(_){

    }catch(_){

    }
  }
}
