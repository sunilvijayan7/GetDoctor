
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:getdoctor/features/presentation/cubit/my_appointment/my_appointment_cubit.dart';
import 'package:getdoctor/features/presentation/pages/single_communication_page.dart';
import 'package:getdoctor/features/presentation/pages/single_item_appointment_user_page.dart';
import 'package:getdoctor/features/presentation/pages/single_item_chat_user_page.dart';

class ODPPage extends StatefulWidget {
  final String uid;

  const ODPPage({Key key, this.uid}) : super(key: key);
  @override
  _ODPPageState createState() => _ODPPageState();
}

class _ODPPageState extends State<ODPPage> {


  @override
  void initState() {
    BlocProvider.of<MyAppointmentCubit>(context).getAppointments(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OPD"),
      ),
      body: BlocBuilder<MyAppointmentCubit, MyAppointmentState>(
        builder: (_, myAppointmentState) {
          if (myAppointmentState is MyAppointmentLoaded) {
            return _myAppointmentList(myAppointmentState);
          }
          return _loadingWidget();
        },
      ),
    );
  }
  Widget _emptyListDisplayMessageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color:Colors.green.withOpacity(.4),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            Icons.local_hospital_outlined,
            color: Colors.white.withOpacity(.6),
            size: 40,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "OPD",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.black.withOpacity(.4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _myAppointmentList(MyAppointmentLoaded myChatData) {
    return myChatData.myAppointmentData.isEmpty
        ? _emptyListDisplayMessageWidget()
        : ListView.builder(
      itemCount: myChatData.myAppointmentData.length,
      itemBuilder: (_, index) {
        final myChat=myChatData.myAppointmentData[index];
        return SingleItemAppointmentUserPage(
          name: myChat.recipientName,
          recentSendMessage: myChat.recentTextMessage,
          time: DateFormat('hh:mm a').format(myChat.time.toDate()),
        );
      },
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
