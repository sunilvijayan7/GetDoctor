import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String name,
    String email,
    String uid,
    String profileUrl,
    String accountType,
    bool isOnline,
    String isHide,
  }) : super(
          name: name,
          email: email,
          uid: uid,
          profileUrl: profileUrl,
          accountType: accountType,
          isOnline: isOnline,
          isHide: isHide,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.data()['name'],
      email: snapshot.data()['email'],
      uid: snapshot.data()['uid'],
      profileUrl: snapshot.data()['profileUrl'],
      accountType: snapshot.data()['accountType'],
      isOnline: snapshot.data()['isOnline'],
      isHide: snapshot.data()['isHide'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "profileUrl": profileUrl,
      "accountType": accountType,
      "isOnline": isOnline,
      "isHide": isHide,
    };
  }
}
