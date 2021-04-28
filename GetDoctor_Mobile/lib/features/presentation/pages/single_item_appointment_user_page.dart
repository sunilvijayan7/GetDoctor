import 'package:flutter/material.dart';

class SingleItemAppointmentUserPage extends StatelessWidget {
  final String time;
  final String recentSendMessage;
  final String name;

  const SingleItemAppointmentUserPage(
      {Key key, this.time, this.recentSendMessage, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(.2),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 55,
                      width: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Image.asset("assets/default_profile.png"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Patient: $name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Appointment: $recentSendMessage",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Text("$time")
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 10),
            child: Divider(
              thickness: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
