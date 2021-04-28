

import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalEntity {
  final String hospitalFullAddress;
  final String hospitalPicUrl;
  final String emergency;
  final String hospitalId;
  final String hospitalName;
  final GeoPoint location;
  final List<String> departments;

  HospitalEntity(
      {this.hospitalFullAddress,
      this.hospitalPicUrl,
      this.emergency,
      this.hospitalId,
      this.hospitalName,
      this.location,
      this.departments,
      });

}