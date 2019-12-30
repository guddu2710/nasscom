import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/model/detailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AttendessD extends StatefulWidget {
  Attendess attendess;
  String route;
  AttendessD({Key key, this.attendess, this.route}) : super(key: key);
  @override
  _AttendessState createState() => _AttendessState();
}

class _AttendessState extends State<AttendessD> {
  Attendess attendess;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attendess = widget.attendess;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(attendess == null
            ? ""
            : attendess.userInformations.firstName +
                " " +
                attendess.userInformations.lastName),
      ),
      body: Container(
        color: Colors.white,
        child: AttendessDetails(),
      ),
    );
  }

  Container AttendessDetails() {
    bool _image = false;
    bool image = false;
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(
                        40.0,
                      ),
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          placeholder: new AssetImage(
                            'image/usernew.png',
                          ),
                          image: NetworkImage(
                              attendess.image==null?Config.imageBaseurl +
                              "users/"
                             :Config.imageBaseurl +
                              "users/"+ attendess.image))),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(attendess == null
                    ? ""
                    : attendess.userInformations.firstName +
                        " " +
                        attendess.userInformations.lastName)),
          ),
          Align(
              alignment: Alignment.center,
              child: Text(attendess.userInformations.designation == null
                  ? ""
                  : "(${attendess.userInformations.designation})")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: Colors.red[800],
                    content: Text('Facebook not connected'),
                    duration: Duration(seconds: 2),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    MdiIcons.facebook,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: Colors.red[800],
                    content: Text('LinkedIn not Connected'),
                    duration: Duration(seconds: 2),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    MdiIcons.linkedin,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: Container(
              height: 2.0,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                attendess == null || attendess.userInformations.about == null
                    ? ""
                    : attendess.userInformations.about,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
