import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:getdoctor/app_const.dart';
import 'package:getdoctor/features/data/models/user_model.dart';
import 'package:getdoctor/features/presentation/cubit/communication/communication_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/my_appointment/my_appointment_cubit.dart';
import 'package:getdoctor/features/presentation/cubit/user/user_cubit.dart';

class SingleCommunicationPage extends StatefulWidget {
  final String senderUID;
  final String recipientUID;
  final String senderName;
  final String recipientName;

  const SingleCommunicationPage({
    Key key,
    this.senderUID,
    this.recipientUID,
    this.senderName,
    this.recipientName,
  }) : super(key: key);

  @override
  _SingleCommunicationPageState createState() =>
      _SingleCommunicationPageState();
}

class _SingleCommunicationPageState extends State<SingleCommunicationPage> {
  TextEditingController _textMessageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController _setYourTimeController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<CommunicationCubit>(context).getMessages(
      senderId: widget.senderUID,
      recipientId: widget.recipientUID,
    );
    _textMessageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    _scrollController.dispose();
    _setYourTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (ctx, userState) {
        if (userState is UserLoaded) {
          final user = userState.data.firstWhere(
              (user) => user.uid == widget.senderUID,
              orElse: () => UserModel());
          return Scaffold(
            appBar: AppBar(
              title: Container(
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        )),
                    Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          child: Image.asset("assets/default_profile.png")),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.recipientName}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                if (user.accountType == AppConst.patient)
                  InkWell(
                    onTap: () {
                      showAlertDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Row(
                        children: [
                          Icon(FontAwesome.stethoscope),
                          Text(
                            "OPD",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            body: BlocBuilder<CommunicationCubit, CommunicationState>(
              builder: (_, communicationState) {
                if (communicationState is CommunicationLoaded) {
                  return _bodyWidget(communicationState);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _bodyWidget(CommunicationLoaded communicationState) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Image.asset(
            "assets/background_wallpaper.png",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            _messagesListWidget(communicationState),
            _sendMessageTextField(),
          ],
        )
      ],
    );
  }

  Widget _messagesListWidget(CommunicationLoaded messages) {
    Timer(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInQuad,
      );
    });
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.messages.length,
        itemBuilder: (_, index) {
          final message = messages.messages[index];

          if (message.sederUID == widget.senderUID) if (message.messsageType ==
              AppConst.odpMessage)
            return _messageLayoutODP(
              isOPD: message.isOdp,
              color: message.isOdp == false
                  ? Colors.lightGreen[400]
                  : Colors.lightGreen[700],
              time: DateFormat('hh:mm a').format(message.time.toDate()),
              align: TextAlign.left,
              senderUID: message.sederUID,
              messageId: message.messageId,
              message: message.message,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              text: message.message,
            );
          else
            return _messageLayout(
              color: Colors.lightGreen[400],
              time: DateFormat('hh:mm a').format(message.time.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.end,
              nip: BubbleNip.rightTop,
              text: message.message,
            );
          else
          if (message.messsageType ==
              AppConst.odpMessage)
            return _messageLayoutODP(
              isOPD: message.isOdp,
              color: message.isOdp == false
                  ? Colors.lightGreen[400]
                  : Colors.lightGreen[700],
              message: message.message,
              senderUID: message.sederUID,
              messageId: message.messageId,
              time: DateFormat('hh:mm a').format(message.time.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.start,
              nip: BubbleNip.leftTop,
              text: message.message,
            );
          else
            return _messageLayout(
              color: Colors.white,
              time: DateFormat('hh:mm a').format(message.time.toDate()),
              align: TextAlign.left,
              boxAlign: CrossAxisAlignment.start,
              crossAlign: CrossAxisAlignment.start,
              nip: BubbleNip.leftTop,
              text: message.message,
            );
        },
      ),
    );
  }

  Widget _sendMessageTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: Offset(0.0, 0.50),
                        spreadRadius: 1,
                        blurRadius: 1),
                  ]),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 60,
                      ),
                      child: Scrollbar(
                        child: TextField(
                          maxLines: null,
                          style: TextStyle(fontSize: 14),
                          controller: _textMessageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              if (_textMessageController.text.isNotEmpty) {
                _sendTextMessage();
              }
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: align,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _messageLayoutODP({
    text,
    time,
    color,
    align,
    boxAlign,
    String senderUID,
    String messageId,
    bool isOPD,
    String message,
    nip,
    crossAlign,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Appointment: $text",
                    textAlign: align,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  senderUID == widget.senderUID
                      ? Container(
                    constraints: BoxConstraints(maxWidth: 180),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(isOPD==false?"process":"accept",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.5)),),
                            InkWell(
                                onTap: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .deleteSingleMessage(
                                    messageId: messageId,
                                    recipientId: widget.recipientUID,
                                    senderId: widget.senderUID,
                                  );
                                  BlocProvider.of<MyAppointmentCubit>(context)
                                      .deleteMyAppointment(
                                      recipientId: widget.recipientUID,
                                      senderId: widget.senderUID,
                                      recipientName: widget.recipientName,
                                      senderName: widget.senderName,
                                      message: _setYourTimeController.text,
                                      messageType: AppConst.textMessage);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text("cancel"),
                                ),
                              ),

                          ],
                        ),
                      )
                      : Container(
                          width: 180,
                          constraints: BoxConstraints(maxWidth: 180),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .updateSingleMessage(
                                    messageId: messageId,
                                    recipientId: widget.recipientUID,
                                    senderId: widget.senderUID,
                                    isOPD: isOPD,
                                  );
                                  BlocProvider.of<MyAppointmentCubit>(context)
                                      .confirmAppointment(
                                          recipientId: widget.recipientUID,
                                          senderId: widget.senderUID,
                                          recipientName: widget.recipientName,
                                          senderName: widget.senderName,
                                          message:message,
                                          messageType: AppConst.textMessage);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(isOPD==false?"Confirm":"approved"),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .deleteSingleMessage(
                                    messageId: messageId,
                                    recipientId: widget.recipientUID,
                                    senderId: widget.senderUID,
                                  );
                                  BlocProvider.of<MyAppointmentCubit>(context).deleteMyAppointment(
                                    recipientId: widget.recipientUID,
                                    senderId: widget.senderUID,
                                    recipientName: widget.recipientName,
                                    senderName: widget.senderName,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text("cancel"),
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sendTextMessage() {
    if (_textMessageController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context).sendTextMessage(
          recipientId: widget.recipientUID,
          senderId: widget.senderUID,
          recipientName: widget.recipientName,
          senderName: widget.senderName,
          message: _textMessageController.text,
          messageType: AppConst.textMessage);
      _textMessageController.clear();
    }
  }

  showAlertDialog() {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (_setYourTimeController.text.isEmpty) {
          Fluttertoast.showToast(
              msg: "Select Time",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }
        BlocProvider.of<UserCubit>(context).sendTextMessage(
            recipientId: widget.recipientUID,
            senderId: widget.senderUID,
            recipientName: widget.recipientName,
            senderName: widget.senderName,
            message: _setYourTimeController.text,
            messageType: AppConst.odpMessage);
        _setYourTimeController.clear();
        Navigator.pop(context);
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Container(
                constraints: BoxConstraints(maxHeight: 100),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));

                        final time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(DateTime.now()));
                        final dropDate =
                            DateTimeField.combine(DateTime.now(), time);
                        print(
                            DateFormat("yyyy-MM-dd hh:mm a").format(dropDate));
                        setState(() {
                          _setYourTimeController.value = TextEditingValue(
                              text: DateFormat("yyyy-MM-dd hh:mm a")
                                  .format(dropDate));
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer_outlined,
                                    size: 25,
                                    color: Colors.black.withOpacity(.5)),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  _setYourTimeController.text.isEmpty
                                      ? "Set Time"
                                      : "${_setYourTimeController.text}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(.6)),
                                ),
                              ],
                            ),
                            _setYourTimeController.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _setYourTimeController.clear();
                                      });
                                    },
                                    child: Icon(Icons.close))
                                : Text("")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                okButton,
              ],
            );
          },
        );
      },
    );
  }
}
