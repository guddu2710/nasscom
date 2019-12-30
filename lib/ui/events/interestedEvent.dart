import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/events/eventDetails.dart';
import 'package:event_management/ui/events/model/interested.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InterestedEvents extends StatefulWidget {
  @override
  _InterestedEventsState createState() => _InterestedEventsState();
}

class _InterestedEventsState extends State<InterestedEvents> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  InteresredModel _interesredModel = new InteresredModel();
  int size = 0;
  @override
  void initState() {
    // TODO: implement initState
    _getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Favourite Events"),
      ),
      body: Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new InterestedEventWidget(
              events: _interesredModel.events[index],
            );
          },
          itemCount: _interesredModel.events == null ||
                  _interesredModel.events.length <= 0
              ? 0
              : size,
        ),
      ),
    );
  }

  _getEvents() async {
    // _isloading = true;

    try {
      //  sharedPreferences = await SharedPreferences.getInstance();

      final response = await Services(Config.interested_event)
          .getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _interesredModel = InteresredModel.fromJson(response);
        });
        if (_interesredModel.status) {
          print(_interesredModel);
          if (_interesredModel.status) {
            setState(() {
              size = _interesredModel.events.length;
            });
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_interesredModel.message),
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

class InterestedEventWidget extends StatelessWidget {
  final Events events;
  const InterestedEventWidget({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          border: new Border.all(width: 1.0, color: Colors.grey),
          color: Colors.white70),
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListTile(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) => EventDetails(
                    eId: events.eventId,
                    route: "/interestedEvents",
                    eventName: events.eventTitle,
                    isInterest: true,
                  ),
            );
            Navigator.of(context).pushReplacement(route);
          },
//        leading:
//        Icon(FontAwesomeIcons.solidHeart,color: Color(0xffc00e34),),
//        new FadeInImage(
//          placeholder: new AssetImage('image/logo.png'),
//          image: AssetImage('image/logo.png'),
//        ),
          title: new Text(
            events.eventTitle,
            style: TextStyle(color: Colors.black),
          ),
          trailing: events.eventStatus == "past"
              ? Icon(
                  MdiIcons.eye,
                  color: Color(0xffc00e34),
                  size: 30.0,
                )
              : events.eventStatus == "upcomming"
                  ? Icon(
                      MdiIcons.qrcodeScan,
                      color: Colors.grey,
                      size: 30.0,
                    )
                  : TimeOfDay.now().hour > 09 && TimeOfDay.now().hour < 17
                      ? InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed("/scanScreen"),
                          child: Icon(
                            MdiIcons.qrcodeScan,
                            color: Colors.black,
                            size: 30.0,
                          ))
                      : Icon(
                          MdiIcons.qrcodeScan,
                          color: Colors.grey,
                          size: 30.0,
                        )),
    );
  }
}
