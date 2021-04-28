import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getdoctor/features/presentation/Screens/Login/login_screen.dart';
import 'package:getdoctor/features/presentation/Screens/Signup/components/social_icon.dart';
import 'package:getdoctor/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/login/login_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';
import 'package:getdoctor/features/presentation/widgets/components/already_have_an_account_acheck.dart';
import 'package:getdoctor/features/presentation/widgets/components/rounded_button.dart';
import 'package:getdoctor/features/presentation/widgets/components/text_field_container.dart';

import '../../constants.dart';
import '../home_screen.dart';
import 'components/or_divider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isShowPassword = false;
  String _groupValue="PATIENT";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _googleSignIn() {
    BlocProvider.of<LoginCubit>(context).googleSignIn();
  }

  void _signUpSubmit() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      BlocProvider.of<LoginCubit>(context).signUpSubmit(
          email: _emailController.text, password: _passwordController.text,name: _nameController.text,accountType: _groupValue);
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
        if (userLoginState is LoginSuccess){
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                print("authenticsted");
                return HomeScreen(uid: authState.uid,);
              } else
                print("unauthenticsted");
                return _bodyWidget();
            },
          );
        }
        return _bodyWidget();
      },
    ));
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

  Widget _bodyWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/signup_top.png",
              width: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: MediaQuery.of(context).size.width * 0.25,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _nameController,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                      hintText: "Username",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _emailController,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                      hintText: "Your Email",
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
                      hintText: "Password",
                      counterText: "",
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
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Radio(activeColor: Colors.green,value: "PATIENT", groupValue: _groupValue, onChanged: (value){
                      setState(() {
                        _groupValue=value;
                      });
                    }),
                    Text("Patient",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                    SizedBox(width: 30,),
                    Radio(activeColor: Colors.green,value: "Doctor", groupValue: _groupValue, onChanged: (value){
                      setState(() {
                        _groupValue=value;
                      });
                    }),
                    Text("Doctor",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                  ],
                ),
                RoundedButton(
                  text: "SIGNUP",
                  press: _signUpSubmit,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
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
