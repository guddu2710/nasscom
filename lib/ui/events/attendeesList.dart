import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/about/attendess.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'model/detailsmodel.dart';

class AttendeesList extends StatefulWidget {
  List<Attendess> listAttendees;
  String route;
  AttendeesList({Key key, this.listAttendees, this.route}) : super(key: key);
  @override
  _AttendeesListState createState() => _AttendeesListState();
}

class _AttendeesListState extends State<AttendeesList> {
  List<Attendess> listAttendees;
  @override
  void initState() {
    // TODO: implement initState
    listAttendees = widget.listAttendees;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendess"),
      ),
      body: Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new AttendeesWidget(
              attendee: listAttendees[index],
            );
          },
          itemCount: listAttendees.length < 0 ? 0 : listAttendees.length,
        ),
      ),
    );
  }
}

class AttendeesWidget extends StatelessWidget {
  final Attendess attendee;
  const AttendeesWidget({Key key, this.attendee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: Colors.white10,
          border: new Border(
            top: BorderSide(color: Colors.grey[300], width: 1.0),
          )),
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListTile(
        onTap: () {
          var route = MaterialPageRoute(
            builder: (BuildContext context) => AttendessD(attendess: attendee),
          );
          Navigator.of(context).push(route);
        },
        leading: Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(25.0),
            border: new Border.all(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          child: new ClipRRect(
              borderRadius: new BorderRadius.circular(
                25.0,
              ),
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 50.0,
                height: 50.0,
                placeholder: new AssetImage(
                  'image/usernew.png',
                ),
                image: NetworkImage(
                  attendee.image == null
                      ? Config.imageBaseurl + "users/"
                      : Config.imageBaseurl + "users/" + attendee.image,
                ),
              )),
        ),
//        new FadeInImage(
//          placeholder: new AssetImage('image/logo.png'),
//          image: AssetImage('image/logo.png'),
//        ),
        title: new Text(
          attendee.userInformations.firstName +
              " " +
              attendee.userInformations.lastName,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
