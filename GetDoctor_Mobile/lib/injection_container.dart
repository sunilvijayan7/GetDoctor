import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getdoctor/features/domain/use_cases/add_to_my_chat_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/add_to_my_chat_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/delete_my_appointment_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/delete_my_appointment_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/delete_single_message_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/delete_single_message_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_appointments_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_appointments_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_create_current_user_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_hospital.dart';
import 'package:getdoctor/features/domain/use_cases/get_hospital.dart';
import 'package:getdoctor/features/domain/use_cases/get_my_chat_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_my_chat_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_text_messages_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/get_text_messages_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/google_sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/google_sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/my_appointment_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/my_appointment_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/send_message_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/send_message_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_in_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_up_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/sign_up_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/update_single_message_usecase.dart';
import 'package:getdoctor/features/domain/use_cases/update_single_message_usecase.dart';
import 'package:getdoctor/features/presentation/cubit/communication/communication_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/communication/communication_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital/get_hospital_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital/get_hospital_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital_details/get_hospital_details_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital_details/get_hospital_details_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/google_auth/google_auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/google_auth/google_auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'features/data/data_sources/firebase_remote_data_source.dart';
import 'features/data/data_sources/firebase_remote_data_source_impl.dart';
import 'features/data/repositories/firebase_repository_impl.dart';
import 'features/domain/repositories/firebase_repository.dart';
import 'features/domain/use_cases/create_one_to_one_chat_channel_usecase.dart';
import 'features/domain/use_cases/get_all_users_usecase.dart';
import 'features/domain/use_cases/get_current_uid_usecase.dart';
import 'features/domain/use_cases/get_hospital_details.dart';
import 'features/domain/use_cases/get_messages_usecase.dart';
import 'features/domain/use_cases/get_one_to_one_single_user_channel_id.dart';
import 'features/domain/use_cases/is_sign_in_usecase.dart';
import 'features/domain/use_cases/send_text_message_usecase.dart';
import 'features/domain/use_cases/sign_out_usecase.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/login/login_cubit.dart';
import 'features/presentation/cubit/my_appointment/my_appointment_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //futures bloc
  sl.registerFactory<AuthCubit>(() =>
      AuthCubit(
        isSignInUseCase: sl.call(),
        signOutUseCase: sl.call(),
        getCurrentUIDUseCase: sl.call(),
      ));
  sl.registerFactory<UserCubit>(() =>
      UserCubit(
        getAllUsersUseCase: sl.call(),
        createOneToOneChatChannelUseCase: sl.call(),
        sendMessageUseCase: sl.call(),
        addToMyChatUseCase: sl.call(),
        getOneToOneSingleUserChatChannelUseCase: sl.call(),
        deleteSingleMessageUseCase: sl.call(),
        updateSingleMessageUseCase: sl.call(),
      ));

  sl.registerFactory<LoginCubit>(() =>
      LoginCubit(
        signUpUseCase: sl.call(),
        signInUseCase: sl.call(),
        googleSignInUseCase: sl.call(),
        getCreateCurrentUserUseCase: sl.call(),
      ));

  sl.registerFactory<CommunicationCubit>(() =>
      CommunicationCubit(
        addToMyChatUseCase: sl.call(),
        getOneToOneSingleUserChatChannelUseCase: sl.call(),
        getTextMessagesUseCase: sl.call(),
        sendTextMessageUseCase: sl.call(),
      ));
  sl.registerFactory<MyChatCubit>(() =>
      MyChatCubit(
        getMyChatUseCase: sl.call(),
      ));

  sl.registerFactory<GoogleAuthCubit>(() =>
      GoogleAuthCubit(
        googleSignInUseCase: sl.call(),
      ));
  sl.registerFactory<GetHospitalCubit>(() =>
      GetHospitalCubit(
          getHospitalUseCase: sl.call()
      ));
  sl.registerFactory<GetHospitalDetailsCubit>(() =>
      GetHospitalDetailsCubit(
        getHospitalDetailsUseCase: sl.call(),
      ));
  sl.registerFactory<MyAppointmentCubit>(() =>
      MyAppointmentCubit(
        getOneToOneSingleUserChatChannelUseCase: sl.call(),
        myAppointmentUseCase: sl.call(),
        deleteMyAppointmentUseCase: sl.call(),
        getAppointmentUseCase: sl.call()
      ));

  //UseCase
  sl.registerLazySingleton<GetAppointmentUseCase>(
          () => GetAppointmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteMyAppointmentUseCase>(
          () => DeleteMyAppointmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<MyAppointmentUseCase>(
          () => MyAppointmentUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateSingleMessageUseCase>(
          () => UpdateSingleMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteSingleMessageUseCase>(
          () => DeleteSingleMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendMessageUseCase>(
          () => SendMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetMyChatUseCase>(
          () => GetMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUIDUseCase>(
          () => GetCurrentUIDUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
          () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
          () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetAllUsersUseCase>(
          () => GetAllUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton<CreateOneToOneChatChannelUseCase>(
          () => CreateOneToOneChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetOneToOneSingleUserChannelIdUseCase>(
          () => GetOneToOneSingleUserChannelIdUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetOneToOneSingleUserChatChannelUseCase>(
          () => GetOneToOneSingleUserChatChannelUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetMessageUseCase>(
          () => GetMessageUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendTextMessageUseCase>(
          () => SendTextMessageUseCase());
  sl.registerLazySingleton<GoogleSignInUseCase>(
          () => GoogleSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
          () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<AddToMyChatUseCase>(
          () => AddToMyChatUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetTextMessagesUseCase>(
          () => GetTextMessagesUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetHospitalUseCase>(
          () => GetHospitalUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetHospitalDetailsUseCase>(
          () => GetHospitalDetailsUseCase(repository: sl.call()));


  //repository
  sl.registerLazySingleton<FirebaseRepository>(
          () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //data source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
          () =>
          FirebaseRemoteDataSourceImpl(
            googleSignInAuth: sl.call(),
            auth: sl.call(),
            fireStore: sl.call(),
          ));

  //external
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final googleSignInAuth = GoogleSignIn();
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => googleSignInAuth);
}
