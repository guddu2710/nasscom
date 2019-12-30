import 'dart:async';
import 'dart:ui' as ui;

import 'dart:convert';
import 'package:event_management/ui/dashboard/CustomDialog.dart';
import 'package:event_management/ui/events/eventDetails.dart';
import 'package:event_management/ui/events/scanScreen.dart';
import 'package:event_management/ui/notification/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/util/event_icons_icons.dart';
import 'package:event_management/util/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CountModel.dart';
import 'DashBoardModel.dart';
TextStyle defaultStyle = TextStyle(fontSize:15, color: Colors.black);

class Dashboard extends StatefulWidget {
  String route;
  Dashboard({Key key, this.route}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isRegistration;
  Timer timer;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  var date;
  DashboardModel _dashboardModel = new DashboardModel();
  DateTime currentBackPressTime;
  int sizepromotion = 0;
  int sizeNews = 0;
  String UserId;
  int upComming = 0;
  bool isClickedPromotion = false;
  bool isClickedNews = false;
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int mCount = 0, nCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message hghh $message');
        _getCount();
        _getmCount();
        if (message['type'] == "notification") {
          sharedPreferences.setInt(
              "nCount", sharedPreferences.getInt("nCount") + 1);
        } else {
          sharedPreferences.setInt(
              "mCount", sharedPreferences.getInt("mCount") + 1);
        }
      },
      onResume: (Map<String, dynamic> message) {
        _getCount();
        _getmCount();
        print('on resume $message');
        if (message['data']["type"] == "notification") {
          // Navigator.of(context).pushNamed("/notificationpage");
        //  Navigator.of(context).pushNamed("/notificationpage");
          var route = MaterialPageRoute(
            builder: (BuildContext context) => Notificationpage(route: "/dashboard",
            ),
          );
          Navigator.of(context).push(route);
//          var route = MaterialPageRoute(
//            builder: (BuildContext context) => Dashboard(route: "/notificationpage",
//            ),
//          );
//          Navigator.of(context).push(route);
        } else {
//          sharedPreferences.setInt(
//              "mCount", sharedPreferences.getInt("mCount") + 1);
          Navigator.of(context).pushNamed("/chatScreen");
        }
      },
      onLaunch: (Map<String, dynamic> message) {
              _getCount();
      _getmCount();
        print('on launch $message');

      },
    );
    if (widget.route == null) {
    } else {
      Navigator.of(context).pushNamed(widget.route);
    }
    getUserId();
    s();
    _getCount();
    _getmCount();
//    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
//      print("timer");
//      _getCount();
//      _getmCount();
//    });

    _getDashBoard();
    date = new DateTime.now();
    DateTime dateTime;
    TimeOfDay.now();
    print(TimeOfDay.now().hour);
    TimeOfDay start_time = TimeOfDay(hour: 09, minute: 0); // 9:00am
    TimeOfDay end_time = TimeOfDay(hour: 18, minute: 0); //5:00pm
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
    print(DateFormat("MM/dd/yyyy").parse("11/19/2019").isAfter(date));

    //print(date);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (Route r) => r == null);
              },
            ),
          ],
        );
      },
    );
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
          sharedPreferences.setInt("notificationCount",nCount);

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

  _getmCount() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var id = sharedPreferences.getString("mId");
      print("idd++$id");
      if (id == null) {
        id = "0";
      }
      print(Config.count + id);
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
//      print(e.toString());
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Toast.show(
            "double tap to exit",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        } else {
          SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
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
//                            Navigator.of(context).pushNamed("/dashboard");
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
                            Navigator.of(context)
                                .pushNamed("/interestedEvents");
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
//                              sharedPreferences.remove("logged");
//                              Navigator.of(context).pushNamedAndRemoveUntil(
//                                  '/login', (Route r) => r == null);
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
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  actions: <Widget>[
                    new IconButton(
                        icon: Icon(
                          FontAwesomeIcons.calendarAlt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/eventList");
                        }),
                    InkWell(
                      onTap: () {
                        setState(() {
                          nCount = 0;
                        });
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => Notificationpage(route: "/dashboard",
                          ),
                        );
                        Navigator.of(context).push(route);
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
                                  builder: (BuildContext context) => Notificationpage(route: "/dashboard",
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
                    SizedBox(
                      width: 10.0,
                    )
                  ],
                ),
                sizepromotion == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Promotions",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((builder, index) {
                  return _dashboardModel.data.promotion[index].type ==
                          "text_type"
                      ? PromotionWidgetText(
                          text:
                              _dashboardModel.data.promotion[index].description,
                        )
                      : PromotionWidgetimg(
                          image: _dashboardModel.data.promotion[index].image,
                        );
                }, childCount: sizepromotion)),
                sizepromotion < 2
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            )
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: isClickedPromotion
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            sizepromotion = 2;
                                            isClickedPromotion = false;
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, right: 15.0),
                                                child: Icon(
                                                  MdiIcons.arrowUpDropCircle,
                                                  color: Colors.grey,
                                                )),
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            isClickedPromotion = true;
                                            sizepromotion = _dashboardModel
                                                .data.promotion.length;
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0, left: 5.0),
                                                child: Icon(
                                                  MdiIcons.arrowDownDropCircle,
                                                  color: Colors.grey,
                                                )),
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        )),
                              ),
                            ),
                          ],
                        ),
                      ),
                sizeNews == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Important news",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                sizeNews == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((builder, index) {
                        return NewsWidget(
                          news: _dashboardModel.data.impotentNews[index].news,
                          image: _dashboardModel.data.impotentNews[index].image,
                        );
                      }, childCount: sizeNews)),
                sizeNews < 2
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            )
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: isClickedNews
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            sizeNews = 2;
                                            isClickedNews = false;
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0, left: 5.0),
                                                child: Icon(
                                                  MdiIcons.arrowUpDropCircle,
                                                  color: Colors.grey,
                                                )),
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            sizeNews = _dashboardModel
                                                .data.impotentNews.length;
                                            isClickedNews = true;
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: Icon(
                                                  MdiIcons.arrowDownDropCircle,
                                                  color: Colors.grey,
                                                )),
                                            new Flexible(
                                              child: new Container(
                                                height: 3.0,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                upComming == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Upcoming Events",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                upComming == 0
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((builder, index) {
                        return EventWidget(
                            upcomingEvents:
                                _dashboardModel.data.upcomingEvents[index],
                            isAfter: (DateFormat("MM/dd/yyyy")
                                .parse(
                                    "${_dashboardModel.data.upcomingEvents[index].startDate}")
                                .isAfter(date)),
                            context: context,
                            UserId: UserId,
                            isRegistration: isRegistration);
                      }, childCount: upComming > 2 ? 2 : upComming)),
                upComming < 2
                    ? SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 1.0,
                            ),
                          ],
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [



                            Container(
                              height: 40.0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.of(context)
                                          .pushNamed("/eventList");
                                    });
                                  },
                                  child: Container(
                                      height: 20.0,
                                      child: Row(
                                        children: <Widget>[
                                          new Flexible(
                                            child: new Container(
                                              height: 3.0,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Text("View more",style: TextStyle(color: Color(0xffc00e34),fontWeight: FontWeight.w600),)),
                                          new Flexible(
                                            child: new Container(
                                              height: 3.0,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ) // new
          ),
    );
  }

  Future<void> _refresh() {
    return _getDashBoard();
  }

  _getDashBoard() async {
    // _isloading = true;

    try {
      sharedPreferences = await SharedPreferences.getInstance();

      final response =
          await Services(Config.dashboard).getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _dashboardModel = DashboardModel.fromJson(response);
        });
        if (_dashboardModel.status) {
          if (_dashboardModel.data.promotion.length > 2) {
            setState(() {
              sizepromotion = 2;
            });
          } else {
            setState(() {
              sizepromotion = _dashboardModel.data.promotion.length;
            });
          }
          if (_dashboardModel.data.impotentNews.length > 2) {
            setState(() {
              sizeNews = 2;
            });
          } else {
            setState(() {
              sizeNews = _dashboardModel.data.impotentNews.length;
            });
          }
          setState(() {
            upComming = _dashboardModel.data.upcomingEvents.length;
          });
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_dashboardModel.message),
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
  _logout() async {
    try {
      var url = Config.logout;
      print("");
      var formData = {"":""};
      final response =
      await Services(url).postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        Toast.show(
          " Something went wrong",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        setState(() {

        });
      }
    } catch (e) {
      print(e.toString());

      Toast.show(
        "product Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
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

  _launchCaller() async {
    const url = "tel:";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var Id = await this.sharedPreferences.get('id');

    setState(() {
      UserId = Id;
    });
  }

  void s() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey("mCount")) {
      sharedPreferences.setInt("mCount", 0);
    }
    if (!sharedPreferences.containsKey("nCount")) {
      sharedPreferences.setInt("nCount", 0);
    }
  }
}

class PromotionWidgetimg extends StatelessWidget {
  final String image;
  const PromotionWidgetimg({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: InkWell(
          onTap: (){
            showGallery(context);
           // _showMenu(context);
          },
          child: Container(
            margin: new EdgeInsets.symmetric(vertical: 2.0),
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            child: FadeInImage(
              placeholder: new AssetImage('image/banner.jpeg'),
              fit: BoxFit.fill,
              image: NetworkImage(Config.imageBaseurl + "promotion/$image"),
            ),
            decoration: new BoxDecoration(
//            image: new DecorationImage(
//                fit: BoxFit.fill,
//                image: new AssetImage(
//                    image)
//            ),
              border: new Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
  showGallery(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Material(

          type: MaterialType.canvas,
          color: Colors.black45,
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(Config.imageBaseurl + "promotion/$image",scale:1.0),
                              initialScale: PhotoViewComputedScale.contained * 1,
                              minScale:  PhotoViewComputedScale.contained * 1
//                      heroAttributes: HeroAttributes(tag: galleryItems[index].id),
                          );
                        },
                        itemCount: 1,
                        //loadingChild: widget.loadingChild,
                        backgroundDecoration:BoxDecoration(color: Colors.black45),
                        // pageController: widget.pageController,
                        // onPageChanged: onPageChanged,
                      )
                  ),
                ),
              ),
              Positioned(
                right: 0.2,
                top: 0.8,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }


}

class PromotionWidgetText extends StatelessWidget {
  final String text;
  const PromotionWidgetText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              _showMenu(context);
            },
            child: Center(
              child: ReadMoreText(
                "$text",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                trimLines: 3,
                colorClickableText: Color(0xffc00e34),
                trimMode: TrimMode.Line,
                trimCollapsedText: '...Read more',
                trimExpandedText: ' Less',
              ),
            ),
          ),
        ),
        decoration: new BoxDecoration(
            color: Colors.white10,
            border: new Border(
                top: BorderSide(color: Colors.grey[300], width: 1.0),
                )),
        margin: new EdgeInsets.symmetric(vertical: 1.0),
      ),
    );
  }
  _showMenu(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => new AlertDialog(
        content: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();

                      },
                      child: Icon(
                        MdiIcons.closeCircle,
                        size: 30.0,
                        color: Colors.red,
                      )),
                ),
                SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        text == null
                            ? ""
                            : text,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:10.0),
                RichText(
                  text: TextSpan(
                    children:<TextSpan>[

                      TextSpan(
                          text: "Read more: ", style: TextStyle(fontSize:15, color: Colors.black)),
                      TextSpan(
                          text: 'https://androidkt.com/flutter-richtext-widget-example/',
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            launch('https://www.google.com');
                          },
                          style: TextStyle(fontSize:13,decoration:TextDecoration.underline,color: Colors.blue))
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}

class NewsWidget extends StatelessWidget {
  final String news, image;
  const NewsWidget({Key key, this.news, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          border: new Border(
              top: BorderSide(width: 1.0, color: Colors.grey[300]),
              ),
          color: Colors.white70),
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListTile(
        onTap: (){
          showDialog(context: context, builder: (BuildContext context) => CustomDialog(text: news,url:"http://pitangent.com/"));
          //_showMenu(context);
          },
          leading: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              child: new FadeInImage(
                placeholder: new AssetImage(
                  'image/company.png',
                ),
                image:
                    NetworkImage(Config.imageBaseurl + "importent-news/$image"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: news == null
              ? Text("")
              : Text(
                  news == null ? "" : news.substring(0,news.length>60?50:news.length),

                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  textAlign: TextAlign.justify,
                )),
    );
  }
  Future<ui.Image> _getImage() {
    Completer<ui.Image> completer = new Completer<ui.Image>();
    new NetworkImage('https://i.stack.imgur.com/lkd0a.png')
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) => completer.complete(info.image));
    return completer.future;
  }
  _showMenu(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => new AlertDialog(
        content: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
         Align(
        alignment: Alignment.centerRight,
          child: InkWell(
              onTap: () {
                Navigator.of(context).pop();

              },
              child: Icon(
                MdiIcons.closeCircle,
                size: 20.0,
                color: Colors.red,
              )),
        ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        news == null
                            ? ""
                            : news,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                RichText(
                  text: TextSpan(
                    children:<TextSpan>[

                      TextSpan(
                          text: "Read more: ", style: TextStyle(fontSize:15, color: Colors.black)),
                      TextSpan(
                          text: 'https://androidkt.com/flutter-richtext-widget-example/',
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            launch('https://www.google.com');
                          },
                          style: TextStyle(fontSize:13,decoration:TextDecoration.underline,color: Colors.blue))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class EventWidget extends StatelessWidget {
  final UpcomingEvents upcomingEvents;
  final bool isAfter, isRegistration;
  final BuildContext context;
  final String UserId;

  const EventWidget(
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
//              print("$UserId");
              var route = MaterialPageRoute(
                builder: (BuildContext context) => EventDetails(
                      eId: upcomingEvents.id,
                      route: "/dashboard",
                      eventName: upcomingEvents.title,
                      isInterest: upcomingEvents.interesUsers.contains(UserId),
                    ),
              );
              Navigator.of(context).push(route);
            },
            leading: upcomingEvents.interesUsers.contains(UserId)
                ? InkWell(
                    onTap: () {},
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Color(0xffc00e34),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (!upcomingEvents.interesUsers.contains(UserId))
                        _postInterested(upcomingEvents.id, context);
                      print("$UserId");

//                      var route = MaterialPageRoute(
//                        builder: (BuildContext context) => EventDetails(
//                              eId: upcomingEvents.id,
//                              route: "/dashboard",
//                              eventName: upcomingEvents.title,
//                            ),
//                      );
//                      Navigator.of(context).push(route);
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
                ? InkWell(
                    onTap: () {
                      Toast.show(
                        "Event not started yet",
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.TOP,
                      );
                    },
                    child: Icon(
                      MdiIcons.qrcodeScan,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                  )
                : isRegistration
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/scanScreen");
                        },
                        child: Icon(
                          MdiIcons.qrcodeScan,
                          color: Colors.black,
                          size: 30.0,
                        ))
                    : InkWell(
                        onTap: () {
                          Toast.show(
                            "Event not strated yet",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.TOP,
                          );
                        },
                        child: Icon(
                          MdiIcons.qrcodeScan,
                          color: Colors.grey,
                          size: 30.0,
                        ),
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
          Navigator.of(context).pushReplacementNamed("/dashboard");
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

//  scan() async{
//    var qrResult = await MajaScan.startScan(
//        title: "SCAN",
//        titleColor: Colors.white,
//        flashlightEnable: true
//
//    );
//    print("qr resuit"+qrResult);
//
//    _getEvent(qrResult);
//  }
  _getEvent(barcode) async {
    try {
      var url = Config.qr_code;
      print(url);
      var formData = {
        "event_id": barcode,
      };
      final response = await Services(url).postMethod(formData, context);
      print(response);
      if (response == null) {
        Toast.show(
          "No data available",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      } else {
//        elsevar s=Scan.fromJson(response);
//        if(s.status){
//
//          Toast.show(s.message, context,
//            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM,);
//
//        }
//        else{
//          Navigator.of(context).pop();
//
//          Toast.show(s.message, context,
//            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM,);
//        }
      }
    } catch (e) {
      print(e.toString());

//      setState(() {
//      //  _isloading = false;
//      });
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}

class InterestedModel {
  String message;
  bool status;

  InterestedModel({this.message, this.status});

  InterestedModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
