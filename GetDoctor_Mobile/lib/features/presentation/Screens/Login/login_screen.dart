import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:getdoctor/features/presentation/Screens/Signup/components/or_divider.dart';
import 'package:getdoctor/features/presentation/Screens/Signup/components/social_icon.dart';
import 'package:getdoctor/features/presentation/Screens/Signup/signup_screen.dart';
import 'package:getdoctor/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/login/login_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';
import 'package:getdoctor/features/presentation/widgets/components/already_have_an_account_acheck.dart';
import 'package:getdoctor/features/presentation/widgets/components/rounded_button.dart';
import 'package:getdoctor/features/presentation/widgets/components/text_field_container.dart';
import '../../constants.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isShowPassword = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _googleSignIn() {
    BlocProvider.of<LoginCubit>(context).googleSignIn();
  }

  void _loginUpSubmit() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      BlocProvider.of<LoginCubit>(context).signInInSubmit(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, LoginState userLoginState) {
          if (userLoginState is LoginSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }

        },
        builder: (context, LoginState userLoginState) {
          if (userLoginState is LoginLoading) {
            return _loadingWidget();
          }
          if (userLoginState is LoginSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  print("authenticsted ${authState.uid}");
                  return HomeScreen(uid: authState.uid,);
                } else {
                  print("Unauthenticsted");
                  return _bodyWidget();
                }
              },
            );
          }
          return  _bodyWidget();
        },
      ),
    );
  }
  Widget _loadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Setting up your account, Please Wait",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          SizedBox(height: 30,),
          SpinKitFadingCube(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.red : Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03),
                TextFieldContainer(
                  child: TextField(
                    controller: _emailController,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                      hintText: "your Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    maxLength: 8,
                    controller: _passwordController,
                    obscureText: _isShowPassword == false ? true : false,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Password",
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            if (_isShowPassword == false)
                              _isShowPassword = true;
                            else
                              _isShowPassword = false;
                          });
                        },
                        child: Icon(
                          Icons.visibility,
                          color: kPrimaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: _loginUpSubmit,
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ), (route) => false);
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: Icon(
                        FontAwesome.google_plus,
                        color: Colors.red,
                      ),
                      press: _googleSignIn,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
