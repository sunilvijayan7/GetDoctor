import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getdoctor/features/data/models/doctor_model.dart';
import 'package:getdoctor/features/data/models/hospital_model.dart';
import 'package:getdoctor/features/data/models/my_chat_model.dart';
import 'package:getdoctor/features/data/models/text_message_model.dart';
import 'package:getdoctor/features/data/models/user_model.dart';
import 'package:getdoctor/features/domain/entities/doctor_entity.dart';
import 'package:getdoctor/features/domain/entities/hospital_entity.dart';
import 'package:getdoctor/features/domain/entities/my_chat_entity.dart';
import 'package:getdoctor/features/domain/entities/text_messsage_entity.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  FirebaseFirestore fireStore;
  FirebaseAuth auth;
  final GoogleSignIn googleSignInAuth;

  String _verificationId = "";

  FirebaseRemoteDataSourceImpl({
    this.fireStore,
    this.auth,
    this.googleSignInAuth,
  });

  @override
  Future<void> signIn(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signUp(String email, String password) {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> googleSignIn() async {
    try {
      final userCollection = fireStore.collection("users");
      final GoogleSignInAccount account = await googleSignInAuth.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information = (await auth.signInWithCredential(credential)).user;
      userCollection.doc(auth.currentUser.uid).get().then((user) async {
        if (!user.exists) {
          var newUser = UserModel(
            name: information.displayName,
            uid: information.uid,
            accountType: "PATIENT",
            email: information.email,
            profileUrl: information.photoURL,
            isOnline: false,
            isHide: "false",
          );

          userCollection.doc(information.uid).set(newUser.toDocument());
        }
      }).whenComplete(() {
        print("New User Created Successfully");
      }).catchError((e) {
        print("getInitializeCreateCurrentUser ${e.toString()}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUId();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        uid: uid,
        accountType: user.accountType,
        email: user.email,
        profileUrl: user.profileUrl,
        isOnline: user.isOnline,
        isHide: "false",
      ).toDocument();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
        return;
      } else {
        userCollection.doc(uid).update(newUser);
        print("user already exist");
        return;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser.uid;

  @override
  Future<bool> isSignIn() async => auth.currentUser.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String pinCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: pinCode);
    await auth.signInWithCredential(authCredential);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) {
      print("phone is verified : token ${authCredential.token}");
    };
    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException authCredential) {
      print("phone failed ${authCredential.message},${authCredential.code}");
    };
    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      this._verificationId = verificationId;
      print("time out $verificationId");
    };
    final PhoneCodeSent phoneCodeSent =
        (String verificationID, [int forceResendingToken]) {
      this._verificationId = verificationID;
      print("sendPhoneCode $verificationID");
    };

    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
  }

  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid) {
    final userCollectionRef = fireStore.collection("users");
    print("uid $uid - otherUid $otherUid");
    return userCollectionRef
        .doc(uid)
        .collection('engagedChatChannel')
        .doc(otherUid)
        .get()
        .then((chatChannelId) {
      if (chatChannelId.exists) {
        return chatChannelId.data()['channelId'];
      } else
        return Future.value(null);
    });
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> createOneToOneChatChannel(
      {String uid,
      String otherUid}) async {
    final userCollectionRef = fireStore.collection("users");
    final oneToOneChatChannelRef = fireStore.collection('myChatChannel');

    userCollectionRef
        .doc(uid)
        .collection('engagedChatChannel')
        .doc(otherUid)
        .get()
        .then((chatChannelDoc) {
      if (chatChannelDoc.exists) {
        return;
      }
      //if not exists
      final _chatChannelId = oneToOneChatChannelRef.doc().id;
      var channelMap = {
        "channelId": _chatChannelId,
        "channelType": "oneToOneChat",
      };
      oneToOneChatChannelRef.doc(_chatChannelId).set(channelMap);

      //currentUser
      userCollectionRef
          .doc(uid)
          .collection("engagedChatChannel")
          .doc(otherUid)
          .set(channelMap);

      //OtherUser
      userCollectionRef
          .doc(otherUid)
          .collection("engagedChatChannel")
          .doc(uid)
          .set(channelMap);

      return;
    });
  }

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    print("our Channel Id$channelId");
    print("our Channel Id${textMessageEntity.sederUID}");
    // final messagesRef = fireStore
    //     .collection("myChatChannel")
    //     .doc(channelId)
    //     .collection("messages");

    //MessageId
    // final messageId = messagesRef.doc().id;
    //
    // final newMessage = TextMessageModel(
    //   message: textMessageEntity.message,
    //   messageId: messageId,
    //   messageType: textMessageEntity.messsageType,
    //   recipientName: textMessageEntity.recipientName,
    //   recipientUID: textMessageEntity.recipientUID,
    //   sederUID: textMessageEntity.sederUID,
    //   senderName: textMessageEntity.senderName,
    //   time: textMessageEntity.time,
    // ).toDocument();
    //
    // messagesRef.doc(messageId).set(newMessage);
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final oneToOneChatChannelRef = fireStore.collection("myChatChannel");
    final messagesRef =
        oneToOneChatChannelRef.doc(channelId).collection("messages");

    return messagesRef.orderBy('time').snapshots().map((querySnap) => querySnap
        .docs
        .map((queryDoc) => TextMessageModel.fromSnapShot(queryDoc))
        .toList());
  }

  @override
  Stream<List<HospitalEntity>> getHospitals() {
    final oneToOneChatChannelRef = fireStore.collection("hospital");

    return oneToOneChatChannelRef.snapshots().map((querySnap) => querySnap
        .docs
        .map((queryDoc) => HospitalModel.fromSnapShot(queryDoc))
        .toList());
  }

  @override
  Stream<List<DoctorEntity>> getHospitalDetails(String hospitalId) {
    final doctorRef = fireStore.collection("hospital").doc(hospitalId).collection("doctors");
    return doctorRef.snapshots().map((event) => event.docs.map((e) => DoctorModel.fromSnapShot(e)).toList());
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
    fireStore.collection('users').doc(uid).collection('myChat');

    return myChatRef.orderBy('time', descending: true).snapshots().map(
          (querySnap) => querySnap.docs
          .map((doc) => MyChatModel.fromSnapShot(doc))
          .toList(),
    );
  }

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity)async {
    final myChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myChat');

    final otherChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myChat');

    final myNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.senderName,
      senderUID: myChatEntity.senderPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      recipientName: myChatEntity.recipientName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
    ).toDocument();
    final otherNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.recipientName,
      senderUID: myChatEntity.recipientUID,
      recipientUID: myChatEntity.senderUID,
      recipientName: myChatEntity.senderName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
    ).toDocument();

    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        //Create
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).set(otherNewChat);
        return;
      } else {
        //Update
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).update(otherNewChat);
        return;
      }
    });
  }

  @override
  Future<void> sendMessage(TextMessageEntity textMessageEntity, String channelId) async{
    final messageRef = fireStore
        .collection('myChatChannel')
        .doc(channelId)
        .collection('messages');

    final messageId = messageRef.doc().id;

    final newMessage = TextMessageModel(
      message: textMessageEntity.message,
      messageId: messageId,
      messageType: textMessageEntity.messsageType,
      recipientName: textMessageEntity.recipientName,
      recipientUID: textMessageEntity.recipientUID,
      sederUID: textMessageEntity.sederUID,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
      isOdp: textMessageEntity.isOdp,
    ).toDocument();

    messageRef.doc(messageId).set(newMessage);
  }

  Future<void> deleteSingleMessage(String channelId, String messageId) async {
    final oneToOneChatChannelRef = fireStore.collection("myChatChannel");

    await oneToOneChatChannelRef
        .doc(channelId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
  Future<void> updateSingleMessage(String channelId, String messageId,bool isOPD) async {
    final oneToOneChatChannelRef = fireStore.collection("myChatChannel");
    Map<String, dynamic> messageInfo = Map();
    print("isOPD $isOPD");
    if (isOPD==false) {
      messageInfo['isOdp'] = true;
    }else{
      messageInfo['isOdp'] = false;
    }

    await oneToOneChatChannelRef
        .doc(channelId)
        .collection("messages")
        .doc(messageId)
        .update(messageInfo);
  }

  @override
  Future<void> myAppointment(MyChatEntity myChatEntity)async {
    final myChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myAppointment');

    final otherChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myAppointment');

    final myNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.senderName,
      senderUID: myChatEntity.senderPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      recipientName: myChatEntity.recipientName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
    ).toDocument();
    final otherNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.recipientName,
      senderUID: myChatEntity.recipientUID,
      recipientUID: myChatEntity.senderUID,
      recipientName: myChatEntity.senderName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
    ).toDocument();

    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        //Create
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).set(otherNewChat);
        return;
      } else {
        //Update
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).update(otherNewChat);
        return;
      }
    });
  }

  @override
  Future<void> deleteMyAppointment(MyChatEntity myChatEntity) {
    final myChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myAppointment');

    final otherChatRef = fireStore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myAppointment');

    myChatRef.doc(myChatEntity.recipientUID).delete();
    otherChatRef.doc(myChatEntity.senderUID).delete();
  }

  @override
  Stream<List<MyChatEntity>> getAppointments(String uid) {
    final myChatRef =
    fireStore.collection('users').doc(uid).collection('myAppointment');

    return myChatRef.orderBy('time', descending: true).snapshots().map(
          (querySnap) => querySnap.docs
          .map((doc) => MyChatModel.fromSnapShot(doc))
          .toList(),
    );
  }
}
