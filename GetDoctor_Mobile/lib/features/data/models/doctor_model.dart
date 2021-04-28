import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getdoctor/features/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    String doctorName,
    String specialist,
    String timing,
    String department,
    String profileImage,
    String gender,
    String phoneNumber,
    String email,
    String descriptionDetails,
    String hospitalAddress,
    String qualification,
    String doctorId,
  })
      : super(
          doctorName:doctorName,
          specialist:specialist,
          timing:timing,
          department:department,
          profileImage:profileImage,
          gender:gender,
          phoneNumber:phoneNumber,
          email:email,
          descriptionDetails:descriptionDetails,
          hospitalAddress:hospitalAddress,
          qualification:qualification,
          doctorId:doctorId,
        );
  factory DoctorModel.fromSnapShot(DocumentSnapshot snapshot){
    return DoctorModel(
      doctorName: snapshot.data()['doctorName'],
      specialist: snapshot.data()['specialist'],
      timing: snapshot.data()['timing'],
      department: snapshot.data()['department'],
      profileImage: snapshot.data()['profileImage'],
      gender: snapshot.data()['gender'],
     phoneNumber: snapshot.data()['phoneNumber'],
      email: snapshot.data()['email'],
      descriptionDetails: snapshot.data()['descriptionDetails'],
      hospitalAddress: snapshot.data()['hospitalAddress'],
      qualification: snapshot.data()['qualification'],
      doctorId: snapshot.data()['doctorId'],
    );
  }
}
