import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as lunch;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:getdoctor/features/data/models/user_model.dart';
import 'package:getdoctor/features/domain/entities/hospital_entity.dart';
import 'package:getdoctor/features/domain/entities/user_entity.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital/get_hospital_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/get_hospital_details/get_hospital_details_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';
import 'package:getdoctor/features/presentation/pages/single_communication_page.dart';
import 'package:getdoctor/features/presentation/widgets/common.dart';

class HomePage extends StatefulWidget {
  final LatLng location;
  final MapType mapType;
  final String uid;

  HomePage({Key key, this.location, this.mapType, this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  GoogleMapController _googleMapController;
  Map<PolylineId, Polyline> polyline = <PolylineId, Polyline>{};
  List<LatLng> routes = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) async {
    if (mounted)
      setState(() {
        _googleMapController = controller;
      });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetHospitalCubit>(context).getHospitals();
    // _setMarker();
    print(
        'LocationDatabase ${widget.location.latitude},${widget.location.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    //_setMarker();

    // routes.add(widget.location);
    // markers.add(widget.location);
    // if (markers.isNotEmpty)
    //   if (routes.isNotEmpty) {
    //     _partnerPolyLine(routes);
    //   }

    return Scaffold(
      key: scaffoldState,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded){
            final user=userState.data.firstWhere((element) => element.uid==widget.uid,orElse: () => UserModel());
            return Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set.of(polyline.values),
                  initialCameraPosition:
                  CameraPosition(zoom: 12, target: widget.location),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: BlocBuilder<GetHospitalCubit, GetHospitalState>(
                    builder: (context, getHospitalState) {
                      if (getHospitalState is GetHospitalLoaded) {
                        return Container(
                          height: 175,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            itemCount: getHospitalState.hospitalData.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              _getCoordinates(getHospitalState
                                  .hospitalData[index].hospitalFullAddress);
                              return InkWell(
                                  onTap: () {
                                    _getClickCoordinates(getHospitalState
                                        .hospitalData[index].hospitalFullAddress);
                                    print(getHospitalState
                                        .hospitalData[index].hospitalId);
                                    BlocProvider.of<GetHospitalDetailsCubit>(context).getHospitalDetails(hospitalId:getHospitalState
                                        .hospitalData[index].hospitalId);
                                  },
                                  child: _listItem(
                                      index, getHospitalState.hospitalData));
                            },
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 35,
                  child: BlocBuilder<GetHospitalDetailsCubit,GetHospitalDetailsState>(
                    builder: (context,getHospitalDetailsState){
                      if (getHospitalDetailsState is GetHospitalDetailsLoaded){
                        return Container(

                          width: MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                              maxHeight: 100
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: getHospitalDetailsState.data.length,
                            itemBuilder: (ctx,index){
                              return Container(
                                width: MediaQuery.of(context).size.width/2,
                                height: 90,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.1),
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ]),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(40)),child: Image.asset("assets/default_profile.png",fit: BoxFit.fill,)),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${getHospitalDetailsState.data[index].doctorName}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                          Text("${getHospitalDetailsState.data[index].qualification}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(.6)),),
                                          Text(getHospitalDetailsState.data[index].email=="null"?"Email: --":"${getHospitalDetailsState.data[index].email}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(.6)),),
                                          Text("Gender: ${getHospitalDetailsState.data[index].gender}",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(.6)),),
                                          SizedBox(height: 5,),
                                          InkWell(
                                            onTap: (){
                                              if (getHospitalDetailsState.data[index].doctorId!="null"){
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => SingleCommunicationPage(
                                                  recipientName: getHospitalDetailsState.data[index].doctorName,
                                                  senderUID: user.uid,
                                                  senderName: user.name,
                                                  recipientUID: getHospitalDetailsState.data[index].doctorId,

                                                )));
                                                BlocProvider.of<UserCubit>(context).createChatChannel(
                                                    uid: widget.uid, otherUid: getHospitalDetailsState.data[index].doctorId,
                                                );
                                              }else{
                                                snackBar(msg: "Message is disabled",scaffoldState: scaffoldState);
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color:  getHospitalDetailsState.data[index].doctorId=="null"?Colors.blueGrey:Colors.green[400],
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(8))),
                                                child: Text(
                                                  getHospitalDetailsState.data[index].doctorId=="null"?"Chat disable":"Start Chat",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ],
            );
          }
          return Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(markers.values),
                polylines: Set.of(polyline.values),
                initialCameraPosition:
                    CameraPosition(zoom: 12, target: widget.location),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Loading",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  _partnerPolyLine(List<LatLng> routes) {
    PolylineId _partnerPolylineId =
        PolylineId('PaitenttoHospitalRountePoint001');
    var line = Polyline(
      polylineId: _partnerPolylineId,
      consumeTapEvents: true,
      width: 6,
      color: Colors.red,
      jointType: JointType.bevel,
      points: routes,
    );
    if (mounted)
      setState(() {
        polyline[_partnerPolylineId] = line;
      });
  }

  Widget _listItem(int index, List<HospitalEntity> hospitalData) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15, right: 25, left: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 2,
                spreadRadius: 2)
          ]),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: hospitalData[index].hospitalPicUrl.isEmpty?Image.asset("assets/image.jpeg",fit: BoxFit.cover,):ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(hospitalData[index].hospitalPicUrl,fit: BoxFit.cover,),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${hospitalData[index].hospitalName}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.black.withOpacity(.4),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      "address:${hospitalData[index].hospitalFullAddress}",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(.4)),
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Departments",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(.5)),
                      ),
                      InkWell(
                        onTap: () async {
                          var addresses = await Geocoder.local
                              .findAddressesFromQuery(
                                  hospitalData[index].hospitalFullAddress);
                          var first = addresses.first;

                          //  MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
                          final availableMaps =
                              await lunch.MapLauncher.installedMaps;
                          print(
                              "mapisAvb $availableMaps"); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                          if (await lunch.MapLauncher.isMapAvailable(
                              lunch.MapType.google)) {
                            await lunch.MapLauncher.showMarker(
                                mapType: lunch.MapType.google,
                                coords: lunch.Coords(first.coordinates.latitude,
                                    first.coordinates.longitude),
                                title:
                                    "${hospitalData[index].hospitalFullAddress}");
                          } else {
                            print("not avaiable");
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.green[400],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              "Get Direction",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 25,
                  child: ListView.builder(
                    itemCount: hospitalData[index].departments.length,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, depIndex) {
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 4, top: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(hospitalData[index].departments[depIndex]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getClickCoordinates(String address) async {

    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;

    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(first.coordinates.latitude, first.coordinates.longitude),
            zoom: 10)));
  }

  _getCoordinates(String address) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;

    final MarkerId markerId = MarkerId(address);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(first.coordinates.latitude, first.coordinates.longitude),
      infoWindow: InfoWindow(title: address, snippet: '*'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
