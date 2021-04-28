
import 'package:getdoctor/features/domain/entities/doctor_entity.dart';
import 'package:getdoctor/features/domain/entities/hospital_entity.dart';
import 'package:getdoctor/features/domain/entities/my_chat_entity.dart';
import 'package:getdoctor/features/domain/entities/text_messsage_entity.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<void> verifyPhoneNumber(String phoneNumber);

  Future<void> getCreateCurrentUser(UserEntity user);

  Future<void> signInWithPhoneNumber(String pinCode);

  Future<bool> isSignIn();

  Future<void> signIn(String email,String password);
  Future<void> signUp(String email,String password);
  Future<void> googleSignIn();
  Future<void> signOut();

  Future<String> getCurrentUId();

  Stream<List<UserEntity>> getAllUsers();

  Future<void> createOneToOneChatChannel(
      {String uid, String otherUid});

  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid);

  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId);
  Future<void> sendMessage(TextMessageEntity textMessageEntity,
      String channelId);

  Future<void> deleteSingleMessage(String channelId, String messageId);
  Future<void> updateSingleMessage(String channelId, String messageId,bool isOPD);
  Future<void> myAppointment(MyChatEntity myChatEntity);
  Future<void> deleteMyAppointment(MyChatEntity myChatEntity);
  Stream<List<MyChatEntity>> getAppointments(String uid);
  Stream<List<TextMessageEntity>> getMessages(String channelId);
  Stream<List<HospitalEntity>> getHospitals();
  Stream<List<DoctorEntity>> getHospitalDetails(String hospitalId);
  Stream<List<MyChatEntity>> getMyChat(String uid);
  Future<void> addToMyChat(MyChatEntity myChatEntity);

}