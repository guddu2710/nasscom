import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_model.dart';

class Notificationpage extends StatefulWidget {
  String route;
  Notificationpage({Key key, this.route}) : super(key: key);
  @override
  _NotificationpageState createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotificationModel notificationModel = new NotificationModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    s();
    _getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(widget.route);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Notification"),
        ),
        body: Scaffold(
          key: _scaffoldKey,
          body: Container(
            color: Colors.white,
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new NotificationWidget(
                    notification: (notificationModel.data == null
                        ? ""
                        : notificationModel.data[index].title));
              },
              itemCount: notificationModel.data == null
                  ? 0
                  : notificationModel.data.length,
            ),
          ),
        ),
      ),
    );
  }

  void s() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _getNotification() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var url = Config.getnotification;
      print(url);
      final response = await Services(url).getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          notificationModel = NotificationModel.fromJson(response);
        });
        if (notificationModel.status) {
          setState(() {
            if (notificationModel.data.length > 0) {
              sharedPreferences.setString(
                  "notificationId", notificationModel.data[0].sId);
            } else {
              sharedPreferences.setString("notificationId", "0");
            }
          });
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(notificationModel.messgae),
            duration: Duration(seconds: 3),
          ));
        }
      }
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Color(0xffc00e34),
        content: Text('Something went worng'),
        duration: Duration(seconds: 3),
      ));
//      setState(() {
//      //  _isloading = false;
//      });
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}

class NotificationWidget extends StatelessWidget {
  final String notification;
  const NotificationWidget({Key key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          border: new Border(
              top: BorderSide(width: 1.0, color: Colors.grey[300]),
              bottom: BorderSide(width: 1.0, color: Colors.grey[300])),
          color: Colors.white70),
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListTile(
        leading: Icon(
          MdiIcons.bullhorn,
          color: Color(0xffc00e34),
          size: 30.0,
        ),
//        new FadeInImage(
//          placeholder: new AssetImage('image/logo.png'),
//          image: AssetImage('image/logo.png'),
//        ),
        title: new Text(
          notification == null ? "" : notification,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
