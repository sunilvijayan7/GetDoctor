import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:getdoctor/app_const.dart';
import 'package:getdoctor/features/data/models/user_model.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';
import 'package:getdoctor/features/presentation/pages/corona_virous_page.dart';
import 'package:getdoctor/features/presentation/pages/home_page.dart';
import 'package:getdoctor/features/presentation/pages/messages_page.dart';
import 'package:getdoctor/features/presentation/pages/odp_page.dart';
import 'package:getdoctor/features/presentation/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({Key key, this.uid}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  PageController _pageController;

  get pages => [
        HomePage(location: LatLng(37.419857, -122.078827),uid: widget.uid,),
        CoronaVirusPage(),
        MessagesPage(uid:widget.uid,),
        ProfilePage(uid: widget.uid,),
        ODPPage(uid: widget.uid,),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    BlocProvider.of<UserCubit>(context).getAllUsers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit,UserState>(
      builder: (ctx,userState){
        if (userState is UserLoaded){
          final user=userState.data.firstWhere((user) => user.uid==widget.uid,orElse: () => UserModel());
          print(user.accountType);
          return Scaffold(
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: _selectedIndex,
              showElevation: true, //
              // use this to remove appBar's elevation
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  // _pageController.animateToPage(index,
                  //     duration: Duration(milliseconds: 300), curve: Curves.ease);
                });
              },
              items: [
                BottomNavyBarItem(
                  icon: Icon(FontAwesome.home),
                  title: Text('Home'),
                  activeColor: Colors.red,
                ),
                BottomNavyBarItem(
                    icon: SizedBox(
                        height: 28,
                        width: 28,
                        child: Image.asset('assets/corona.png')),
                    title: Text('Coronavirus'),
                    activeColor: Colors.pink),
                BottomNavyBarItem(
                    icon: Icon(Icons.message),
                    title: Text('Messages'),
                    activeColor: Colors.pink),
                BottomNavyBarItem(
                    icon: Icon(FontAwesome.user_o),
                    title: Text('profile'),
                    activeColor: Colors.purpleAccent),
                if (user.accountType==AppConst.doctor)
                BottomNavyBarItem(
                    icon: Icon(FontAwesome.stethoscope),
                    title: Text('OPD'),
                    activeColor: Colors.purpleAccent),
              ],
            ),
            body: _pageSwitcher(),
          );
        }
        return Scaffold(
          body: _loadingWidget(),
        );
      },
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
  _pageSwitcher() {
    return pages[_selectedIndex];
  }
}
