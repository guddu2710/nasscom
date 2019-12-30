import 'dart:async';
import 'dart:core';
import 'dart:core';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/dashboard/CountModel.dart';
import 'package:event_management/ui/dashboard/dashboard.dart';
import 'package:event_management/ui/events/pasteventdetails.dart';
import 'package:event_management/ui/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventDetails.dart';
import 'model/EventInfo.dart';
import 'model/UpcommingEventModel.dart';
import 'model/pasteventmodel.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PastEventModel _PastEventModel = new PastEventModel();
  Timer timer;
  UpcommingEventModel _upcommingEventModel = new UpcommingEventModel();
  int sizeCome = 0, sizePast = 0;
  List<String> key_name = [];
  List<List<String>> _keyNames = [];
  List<List<EventInfo>> _values = [];
  var events = [];
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  TabController _controller;
  bool notofication = true;
  bool isRegistration;
  SharedPreferences sharedPreferences;
  String UserId;
  int _activeTabIndex = 0;
  int mCount = 0, nCount = 0;

  var date;
  var _eventInfo = new EventInfo();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    s();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message hghh $message');
        _getCount();
        _getmCount();
      },
      onResume: (Map<String, dynamic> message) {
        _getCount();
        _getmCount();
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        _getCount();
        _getmCount();
        print('on launch $message');

      },
    );
    _getCount();
    _getmCount();
//    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
//      print("timer");
//      _getCount();
//      _getmCount();
//    });
    date = new DateTime.now();
    TimeOfDay start_time = TimeOfDay(hour: 09, minute: 0); // 9:00am
    TimeOfDay end_time = TimeOfDay(hour: 17, minute: 0); //5:00pm
    _controller = new TabController(vsync: this, initialIndex: 0, length: 2);
    _controller.addListener(_setActiveTabIndex);

    setState(() {
//      print(start_time);
//      print(TimeOfDay.now().hour>start_time.hour&&TimeOfDay.now().hour<end_time.hour);
//      print(start_time.hour>TimeOfDay.now().hour);
      date = new DateTime.now();
      isRegistration = TimeOfDay.now().hour > start_time.hour &&
          TimeOfDay.now().hour < end_time.hour;

      //  date = new DateFormat("MM/dd/yyyy").format(now);
      //  dateTime = DateTime.parse(date);
    });
    getUserId();
    _getPastEvents();
    _getUpcommingEvents();
  }
  _launchURL(url) async {
    //   const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red[800],
        content: Text('Could not launch $url'),
        duration: Duration(seconds: 2),
      ));
      throw 'Could not launch $url';
    }
  }
  void _setActiveTabIndex() {
    _activeTabIndex = _controller.index;
    if (_activeTabIndex == 0) {
      _getUpcommingEvents();
     // _getCount();
     // _getmCount();
    } else {
      _getPastEvents();
      //_getCount();
      //_getmCount();
    }
    print(_activeTabIndex);
  }

  _getCount() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("notificationId");
      if (id == null) {
        id = "0";
      }
      print(Config.count + "/" + id);
      final response =
          await Services(Config.count + id).getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          backgroundColor: Color(0xffc00e34),
//          content: Text('Server Problem'),
//          duration: Duration(seconds: 3),
//        ));
      } else {
        var countModel = CountModel.fromJson(response);
        setState(() {
          nCount = countModel.count;
        });
      }
    } catch (e) {
      print(e.toString());
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//        backgroundColor: Color(0xffc00e34),
//        content: Text('Something went worng'),
//        duration: Duration(seconds: 3),
//      ));
//      setState(() {
//      //  _isloading = false;
//      });
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

  void getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var Id = await this.sharedPreferences.get('id');

    setState(() {
      UserId = Id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        key: _scaffoldKey,
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                    actions: <Widget>[
                      new IconButton(
                          icon: Icon(
                            FontAwesomeIcons.calendarAlt,
                            color: Colors.yellow,
                          ),
                          onPressed: () {
                            //Navigator.of(context).pushNamed("/eventList");
                          }),
                      InkWell(
                        onTap: () {
                          setState(() {
                            nCount = 0;
                          });
                          var route = MaterialPageRoute(
                            builder: (BuildContext context) => Notificationpage(route: "/eventList",
                            ),
                          );
                          Navigator.of(context).push(route);
                         // Navigator.of(context).pushNamed("/notificationpage");
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            new IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.solidBell,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  var route = MaterialPageRoute(
                                    builder: (BuildContext context) => Notificationpage(route: "/eventList",
                                    ),
                                  );
                                  Navigator.of(context).push(route);
                                }),
                            nCount > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow,
                                        ),
                                        child: Center(
                                            child: Text(
                                          nCount.toString(),
                                          style: TextStyle(
                                              color: Color(0xffc00e34),
                                              fontWeight: FontWeight.w500),
                                        ))),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                    floating: true,
                    pinned: true,
                    title: Text(""),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.black),
                        child: Container(
                          color: Colors.white,
                          height: 48.0,
                          alignment: Alignment.center,
                          child: TabBar(
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  width: 5.0, color: Color(0xffc00e34)),
                            ),
                            labelPadding: EdgeInsets.zero,
                            controller: _controller,
                            tabs: <Widget>[
                              Tab(
                                child: Text(
                                  "UPCOMING EVENT",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "PAST EVENT",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
//                TabBar(
//                  indicatorColor: _activeColor,
//                  labelPadding: EdgeInsets.zero,
//                  controller: _controller,
//                  tabs: _tabs,
//                ),
                    ),
              ];
            },
            body: TabBarView(
              controller: _controller,
              children: <Widget>[
                sizeCome > 0
                    ? Container(
                        color: Colors.white,
                        child: new ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return UpcommingEventWidget(
                                upcomingEvents:
                                    _upcommingEventModel.upcommingEvents[index],
                                isAfter: (DateFormat("MM/dd/yyyy")
                                    .parse(
                                        "${_upcommingEventModel.upcommingEvents[index].startDate}")
                                    .isAfter(date)),
                                context: context,
                                UserId: UserId,
                                isRegistration: isRegistration);
                          },
                          itemCount:
                              _upcommingEventModel.upcommingEvents.length > 0
                                  ? _upcommingEventModel.upcommingEvents.length
                                  : 0,
                        ),
                      )
                    : Container(),
                sizePast > 0
                    ? Container(
                        color: Colors.white,
                        child: new ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return new PastEventWidget(
                              pastEvents: _PastEventModel.pastEvents[index],
                              UserId: UserId,
                            );
                          },
                          itemCount: sizePast,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          // column holds all the widgets in the drawer
          child: Column(
            children: <Widget>[
              Expanded(
                // ListView contains a group of widgets that scroll inside the drawer
                child: Container(
                  color: Colors.black,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 150.0,
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              "image/Spash_screen_back.jpg",
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                            Scaffold(
                                backgroundColor: Colors.transparent,
                                resizeToAvoidBottomInset: false,
                                resizeToAvoidBottomPadding: false,
                                body: Center(
                                  child: Image.asset(
                                    "image/Nasscom.png",
                                    fit: BoxFit.fill,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Home",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          FontAwesomeIcons.home,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/dashboard");
                          print("gi");
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text(
                          "Profile Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/profile");
                          print("gi");
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text(
                          "Message",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: mCount > 0
                            ? Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(15),
                                  border: new Border.all(
                                    width: 2.0,
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  mCount.toString(),
                                  style: TextStyle(
                                    color: Colors.yellowAccent,
                                  ),
                                )))
                            : Text(""),
                        leading: Image.asset("image/admin_message.png"),
                        onTap: () {
                          setState(() {
                            mCount = 0;
                          });
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/chatScreen");
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text(
                          "My Event Calender",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          FontAwesomeIcons.calendarAlt,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/eventList");
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text(
                          "Interested Event List",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/interestedEvents");
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        title: Text(
                          "Support",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Image.asset("image/telephone.png"),
                        onTap: () {
                          Navigator.pop(context);
                          _launchCaller();
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                          title: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Image.asset("image/logout.png"),
                          onTap: () {
                            _showDialog();
//                            sharedPreferences.remove("logged");
//                            Navigator.of(context).pushNamedAndRemoveUntil(
//                                '/login', (Route r) => r == null);
                          }),
                    ],
                  ),
                ),
              ),
              // This container holds the align
              Container(
                  // This align moves the children to the bottom
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      // This container holds all the children that will be aligned
                      // on the bottom and should not scroll with the above ListView
                      child: Container(
                        color: Color(0xffc00e34),
                        child: InkWell(
                          onTap: (){
                            _launchURL("http://pitangent.com/");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "App Development Partner",
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Image.asset(
                                "image/logo.png",
                                height: 60,
                                width: 60.0,
                              )
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation"),
          content: new Text("Are you sure to Logout from this app?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Cancel",style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();

              },
            ),
            new FlatButton(
              child: new Text("Exit"),
              onPressed: () {
                _logout();
                sharedPreferences.setString("notificationId",
                    "0");
                sharedPreferences.setString("mId",
                    "0");
                Navigator.of(context).pop();
                sharedPreferences.remove("logged");
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route r) => r == null);
              },
            ),
          ],
        );
      },
    );
  }

  _launchCaller() async {
    const url = "tel:";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getmCount() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("mId");
      print(id);
      if (id == null) {
        id = "0";
      }
      print(Config.message_count + "/" + id);
      final response = await Services(Config.message_count + id)
          .getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          backgroundColor: Color(0xffc00e34),
//          content: Text('Server Problem'),
//          duration: Duration(seconds: 3),
//        ));
      } else {
        var countModel = CountModel.fromJson(response);
        setState(() {
          mCount = countModel.count;
        });
      }
    } catch (e) {
      print(e.toString());
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//        backgroundColor: Color(0xffc00e34),
//        content: Text('Something went worng'),
//        duration: Duration(seconds: 3),
//      ));
//      setState(() {
//      //  _isloading = false;
//      });
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
  _logout() async {
    try {
      var url = Config.logout;
      var formData = {"": ""};
      final response =
      await Services(url).postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Text("No data available"),
          duration: Duration(seconds: 2),
        ));
      } else {
        setState(() {

        });
      }
    } catch (e) {
      print(e.toString());

      Toast.show(
        " Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  _getUpcommingEvents() async {
    // _isloading = true;

    try {
      //  sharedPreferences = await SharedPreferences.getInstance();

      final response = await Services(Config.upcomming_event)
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
          _upcommingEventModel = UpcommingEventModel.fromJson(response);
        });
        if (_upcommingEventModel.status) {
          print(_upcommingEventModel);
          sizeCome = _upcommingEventModel.upcommingEvents.length;
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_upcommingEventModel.message),
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

  void s() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey("mCount")) {
      sharedPreferences.setInt("mCount", 0);
    }
    if (!sharedPreferences.containsKey("nCount")) {
      sharedPreferences.setInt("mCount", 0);
    }
  }

  _getPastEvents() async {
    // _isloading = true;

    try {
      //  sharedPreferences = await SharedPreferences.getInstance();

      final response =
          await Services(Config.past_event).getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _PastEventModel = PastEventModel.fromJson(response);
        });
        if (_PastEventModel.status) {
          print(_PastEventModel);
          if (_PastEventModel.status) {
            setState(() {
              sizePast = _PastEventModel.pastEvents.length;
            });
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_PastEventModel.message),
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

class UpcommingEventWidget extends StatelessWidget {
  final UpcommingEvents upcomingEvents;
  final bool isAfter, isRegistration;
  final BuildContext context;
  final String UserId;

  const UpcommingEventWidget(
      {Key key,
      this.upcomingEvents,
      this.isAfter,
      this.isRegistration,
      this.context,
      this.UserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: new Container(
          decoration: new BoxDecoration(
              border: new Border(
                  top: BorderSide(width: 1.0, color: Colors.grey[300]),
                  ),
              color: Colors.white70),
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new ListTile(
            onTap: () {
//              if (!upcomingEvents.interesUsers.contains(UserId))
//                _postInterested(upcomingEvents.id, context);
              print("$UserId");
              var route = MaterialPageRoute(
                builder: (BuildContext context) => EventDetails(
                      eId: upcomingEvents.id,
                      route: "/eventList",
                      eventName: upcomingEvents.title,
                      isInterest: upcomingEvents.interesUsers.contains(UserId),
                    ),
              );
              Navigator.of(context).pushReplacement(route);
            },
            leading: upcomingEvents.interesUsers.contains(UserId)
                ? InkWell(
                    onTap: () {},
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Color(0xffc00e34),
                    ))
                : InkWell(
                    onTap: () {
                      if (!upcomingEvents.interesUsers.contains(UserId))
                        _postInterested(upcomingEvents.id, context);
                      print("$UserId");
                    },
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.grey,
                    ),
                  ),
            title: new Text(
              upcomingEvents.title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: isAfter
                ? Icon(
                    MdiIcons.qrcodeScan,
                    color: Colors.grey,
                    size: 30.0,
                  )
                : isRegistration
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
                      ),
          ),
        ),
      ),
    );
  }

  _postInterested(String _id, BuildContext context) async {
    print(_id);
    try {
      var formData = {
        "event_id": _id,
      };
      final response =
          await Services(Config.interested_uesr).postMethod(formData, context);
      print(response);
      if (response == null) {
      } else {
        var intersest = InterestedModel.fromJson(response);
        if (intersest.status) {
          Navigator.of(context).pushReplacementNamed("/eventList");
        } else {}
      }
    } catch (e) {
//      setState(() {
//        _isloading = false;
//      });
//      Toast.show("Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}

class PastEventWidget extends StatelessWidget {
  final PastEvents pastEvents;
  final String UserId;

  const PastEventWidget({Key key, this.pastEvents, this.UserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: new Container(
          decoration: new BoxDecoration(
              border: new Border(
                  top: BorderSide(width: 1.0, color: Colors.grey[300]),
                  ),
              color: Colors.white70),
          margin: new EdgeInsets.symmetric(vertical: 1.0),
          child: new ListTile(
            onTap: () {
              var route = MaterialPageRoute(
                builder: (BuildContext context) => PastEventDetails(
                      eId: pastEvents.id,
                      route: "/eventList",
                      like: pastEvents.interesUsers.contains(UserId),
                    ),
              );
              Navigator.of(context).pushReplacement(route);
            },
            leading: pastEvents.interesUsers.contains(UserId)
                ? Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Color(0xffc00e34),
                  )
                : Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.grey,
                  ),
            title: new Text(
              pastEvents.title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              MdiIcons.eye,
              color: Color(0xffc00e34),
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
