import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getdoctor/features/presentation/Screens/Login/login_screen.dart';
import 'package:getdoctor/features/presentation/cubit/communication/communication_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital/get_hospital_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital_details/get_hospital_details_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/google_auth/google_auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'features/presentation/Screens/home_screen.dart';
import 'features/presentation/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/presentation/cubit/auth/auth_cubit.dart';
import 'features/presentation/cubit/login/login_cubit.dart';
import 'features/presentation/cubit/my_appointment/my_appointment_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>(),
        ),
        BlocProvider<GoogleAuthCubit>(
          create: (_) => di.sl<GoogleAuthCubit>(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => di.sl<LoginCubit>(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => di.sl<CommunicationCubit>(),
        ),
        BlocProvider<GetHospitalCubit>(
          create: (_) => di.sl<GetHospitalCubit>(),
        ),
        BlocProvider<GetHospitalDetailsCubit>(
          create: (_) => di.sl<GetHospitalDetailsCubit>(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => di.sl<MyChatCubit>(),
        ),
        BlocProvider<MyAppointmentCubit>(
          create: (_) => di.sl<MyAppointmentCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Get Doctor',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomeScreen(uid: authState.uid,);
                } else
                  return LoginScreen();
              },
            );
          }
        },
      ),
    );
  }
}
