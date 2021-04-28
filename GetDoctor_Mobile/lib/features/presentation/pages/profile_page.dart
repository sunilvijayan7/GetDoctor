import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:getdoctor/features/data/models/user_model.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'package:getdoctor/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key key, this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  PermissionStatus _permissionGranted;
  Location location = new Location();
  bool _serviceEnabled;
  String address="";

  @override
  void initState() {
    checkLocationPermission();

      location.onLocationChanged.listen((currentLocation){
        print("chekcLocation ${currentLocation.longitude}");


        Geocoder.local.findAddressesFromCoordinates(Coordinates(currentLocation.latitude , currentLocation.longitude)).then((value) {
          setState(() {
            //address="${value.first.subAdminArea},${value.first.featureName},\n${value.first.adminArea},${value.first.countryName}";
          });
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
        body: BlocBuilder<UserCubit,UserState>(
          builder: (_,state){
            if (state is UserLoaded){
              final user=state.data.firstWhere((user) => user.uid==widget.uid,orElse: () => UserModel());
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80,),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.black,width: 1.2)
                        ),
                        child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(100)),child: Image.asset('assets/default_profile.png')),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${user.name}"
                      ,style: TextStyle(
                        fontSize: 25.0,
                        color:Colors.blueGrey,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w400
                    ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      address.isEmpty?"California , USA":address,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color:Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email:${user.email}"
                      ,style: TextStyle(
                        fontSize: 15.0,
                        color:Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Account:${user.accountType }"
                      ,style: TextStyle(
                        fontSize: 15.0,
                        color:Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300
                    ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      child: InkWell(
                        onTap: (){
                          BlocProvider.of<AuthCubit>(context).loggedOut();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(.2),
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Text("SignOut"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return  SpinKitFadingCube(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.red : Colors.green,
                  ),
                );
              },
            );
          },
        ),
    );
  }

  checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

  }
}