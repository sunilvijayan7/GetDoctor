import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:getdoctor/features/presentation/cubit/my_chat/my_chat_cubit.dart';
import 'package:getdoctor/features/presentation/pages/single_communication_page.dart';
import 'package:getdoctor/features/presentation/pages/single_item_chat_user_page.dart';

class MessagesPage extends StatefulWidget {
  final String uid;

  const MessagesPage({Key key, this.uid}) : super(key: key);
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: widget.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: BlocBuilder<MyChatCubit, MyChatState>(
        builder: (_, myChatState) {
          if (myChatState is MyChatLoaded) {
            return _myChatList(myChatState);
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
            Icons.message,
            color: Colors.white.withOpacity(.6),
            size: 40,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Your chat messages",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.black.withOpacity(.4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _myChatList(MyChatLoaded myChatData) {
    return myChatData.myChat.isEmpty
        ? _emptyListDisplayMessageWidget()
        : ListView.builder(
      itemCount: myChatData.myChat.length,
      itemBuilder: (_, index) {
        final myChat=myChatData.myChat[index];
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SingleCommunicationPage(
                senderUID: widget.uid,
                senderName: myChat.senderName,
                recipientUID: myChat.recipientUID,
                recipientName: myChat.recipientName,
              ),
            ));
          },
          child: SingleItemChatUserPage(
            name: myChat.recipientName,
            recentSendMessage: myChat.recentTextMessage,
            time: DateFormat('hh:mm a').format(myChat.time.toDate()),
          ),
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
