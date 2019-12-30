import 'dart:core';
import 'dart:io';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/dashboard/dashboard.dart';
import 'package:event_management/ui/events/about/speaker.dart';
import 'package:event_management/ui/events/exhibitorList.dart';
import 'package:event_management/ui/events/speakersList.dart';
import 'package:event_management/ui/events/sponserList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:event_management/util/read_more_text.dart';

import 'about/attendess.dart';
import 'about/exhibitor.dart';
import 'about/sponser.dart';
import 'attendeesList.dart';
import 'model/detailsmodel.dart';
import 'model/session_model.dart';

class EventDetails extends StatefulWidget {
  String eId;
  String route;
  String eventName;
  bool isInterest;
  EventDetails({Key key, this.eId, this.route, this.eventName, this.isInterest})
      : super(key: key);
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with TickerProviderStateMixin {
  String title;
  bool isGoal = false;
  bool isInterest;
  String dummyText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
  SharedPreferences sharedPreferences;
  String route, eId;
  TabController _controller;
  bool _isComposingMessage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _textEditingControllerGoal =
      new TextEditingController();
  ScrollController _scrollBottomBarController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  bool isScrollingDown = false, _isEdit = false, keyboard = false;
  bool isEdit = false;
  bool pinned = true, isInterested;
  int _activeTabIndex = 0;
  bool isCome = false;
  EventDetailsModel _eventDetailsModel = new EventDetailsModel();
  SessionModel _sessionModel = new SessionModel();
  String UserId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.eventName;
    getUserId();
    this.eId = widget.eId;
    this.isInterest = widget.isInterest;
    this.route = widget.route;
    print(this.route);
    _getEvent();
    //  _getSession();
    _controller = new TabController(vsync: this, initialIndex: 0, length: 4);
    _textEditingControllerGoal.text =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    _controller.addListener(_setActiveTabIndex);
    myScroll();
//    KeyboardVisibilityNotification().addNewListener(
//      onChange: (bool visible) {
//        setState(() {
//          keyboard = visible;
//        });
//        print(visible);
//      },
//    );
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (route == "/dashboard") Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(route);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          key: _scaffoldKey,
          body: DefaultTabController(
            length: 5,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                      primary: true,
                      floating: true,
                      pinned: pinned,
                      title: Text(title),
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
                              onTap: (index) => debugPrint("$index"),
                              tabs: <Widget>[
                                Tab(
                                    child: Icon(
                                  MdiIcons.home,
                                  color: Colors.black54,
                                  size: 25.0,
                                )),
//                                Tab(
//                                    child: Icon(
//                                  MdiIcons.clock,
//                                  color: Colors.black45,
//                                  size: 25.0,
//                                )),
                                Tab(
                                    child: Icon(
                                  MdiIcons.mapMarker,
                                  color: Colors.black54,
                                  size: 25.0,
                                )),
                                Tab(
                                    child: Icon(
                                  MdiIcons.image,
                                  color: Colors.black45,
                                  size: 25.0,
                                )),
                                Tab(
                                    child: Icon(
                                  MdiIcons.bullseyeArrow,
                                  color: Colors.black45,
                                  size: 25.0,
                                ))
                              ],
                            ),
                          ),
                        ),
                      )),
                ];
              },
              body: TabBarView(
                controller: _controller,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Event(),
                  ),
//                  isCome
//                      ? SafeArea(
//                          child: new ListView.builder(
//                              itemCount: _sessionModel.data == null ||
//                                      _sessionModel.data.length <= 0
//                                  ? 0
//                                  : _sessionModel.data.length,
//                              itemBuilder: (context, index) {
//                                return new StickyHeader(
//                                  header: new Container(
//                                    height: 50.0,
//                                    color: Color(0xffc00e34),
//                                    padding: new EdgeInsets.symmetric(
//                                        horizontal: 16.0),
//                                    alignment: Alignment.centerLeft,
//                                    child: new Text(
//                                      '${_sessionModel.data[index].date}',
//                                      style:
//                                          const TextStyle(color: Colors.white),
//                                    ),
//                                  ),
//                                  content: Column(
//                                    children: List<int>.generate(
//                                            _sessionModel.data == null ||
//                                                    _sessionModel
//                                                            .data[index]
//                                                            .sessionTitle
//                                                            .length <=
//                                                        0
//                                                ? 0
//                                                : _sessionModel.data[index]
//                                                    .sessionTitle.length,
//                                            (index) => index)
//                                        .map((item) => Container(
//                                              child: InkWell(
//                                                onTap: () {
//                                                  Navigator.of(context)
//                                                      .pushNamed(
//                                                          "/sessionDetails");
//                                                },
//                                                child: Container(
//                                                  decoration: new BoxDecoration(
//                                                      border: new Border(
//                                                          top: BorderSide(
//                                                              width: 1.0,
//                                                              color: Colors
//                                                                  .grey[300]),
//                                                          bottom: BorderSide(
//                                                              width: 1.0,
//                                                              color: Colors
//                                                                  .grey[300])),
//                                                      color: Colors.white70),
//                                                  width: MediaQuery.of(context)
//                                                      .size
//                                                      .width,
//                                                  child: Column(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment.start,
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
//                                                    children: <Widget>[
//                                                      Padding(
//                                                        padding:
//                                                            const EdgeInsets
//                                                                    .only(
//                                                                top: 10.0,
//                                                                left: 20.0,
//                                                                bottom: 10.0),
//                                                        child: Text(
//                                                          " ${_sessionModel.data[index].sessionTitle[item].sessionTitle}",
//                                                          style: TextStyle(
//                                                              fontSize: 17.0),
//                                                        ),
//                                                      ),
//                                                    ],
//                                                  ),
////                          color: Colors.red[(item + 1) * 100],
//                                                ),
//                                              ),
//                                            ))
//                                        .toList(),
//                                  ),
//                                );
//                              }),
//                        )
//                      : Container(
//                          color: Colors.white,
//                          child: Center(
//                              child: Image.asset(
//                            "image/Coming_Soon.jpg",
//                            width: 250,
//                            height: 250,
//                          )
////            Text("Comming Soon..",style: TextStyle(color: Color(0xffc00e34),fontSize: 18.0),),
//                              ),
//                        ),
                  Container(
                    color: Colors.white,
                    child: Venue(),
                  ),
                  Container(
                    color: Colors.white,
                    child: Gallery(),
                  ),
                  Container(
                    color: Colors.white,
                    child: isGoal
                        ? GoalEvent()
                        : Center(
                            child: Image.asset(
                            "image/Coming_Soon.jpg",
                            width: 250,
                            height: 250,
                          )
//            Text("Comming Soon..",style: TextStyle(color: Color(0xffc00e34),fontSize: 18.0),),
                            ),
                  ),
                ],
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
        setState(() {
        });
        var intersest = InterestedModel.fromJson(response);
        if (intersest.status) {
          setState(() {
            isInterest = true;
          });
        } else {

        }
      }
    } catch (e) {
//      setState(() {
//        _isloading = false;
//      });
//      Toast.show("Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

  Widget Event() {
    return Column(children: <Widget>[
      Expanded(
          child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "About the Event",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      )),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isInterest
                              ? Icon(
                                  MdiIcons.heart,
                                  color: Color(0xffc00e34),
                                  size: 30.0,
                                )
                              : InkWell(
                                  onTap: () {
                                    _postInterested(eId, context);
                                  },
                                  child: Icon(
                                    MdiIcons.heart,
                                    color: Colors.grey,
                                    size: 30.0,
                                  ))),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        _eventDetailsModel.event == null
                            ? ""
                            : DateFormat("MM/dd/yyyy")
                                    .parse(_eventDetailsModel.event.date)
                                    .day
                                    .toString() +
                                "-" +
                                DateFormat("MM/dd/yyyy")
                                    .parse(_eventDetailsModel.event.date)
                                    .month
                                    .toString() +
                                "-" +
                                DateFormat("MM/dd/yyyy")
                                    .parse(_eventDetailsModel.event.date)
                                    .year
                                    .toString(),
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReadMoreText(
                    _eventDetailsModel.event == null
                        ? ""
                        : _eventDetailsModel.event.about,
                    style: TextStyle(color: Colors.grey[600]),
                    trimLines: 4,
                    textAlign: TextAlign.justify,
                    colorClickableText: Color(0xffc00e34),
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Read more',
                    trimExpandedText: ' Less',
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2.0,
            color: Colors.grey,
          ),
          //sponserSection
          _eventDetailsModel.sponsor == null ||
                  _eventDetailsModel.sponsor.length <= 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "SPONSORS",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => SponserList(
                              listSponser: _eventDetailsModel.sponsor),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("View All",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontWeight: FontWeight.w600)))),
                    )
                  ],
                ),
          _eventDetailsModel.sponsor == null ||
                  _eventDetailsModel.sponsor.length <= 0
              ? Container()
              : Container(
                  height: 100.0,
                  child: Center(
                    child: new ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return new SponserWidget(
                          sponsor: _eventDetailsModel.sponsor[index],
                        );
                      },
                      itemCount: _eventDetailsModel.sponsor == null
                          ? 0
                          : _eventDetailsModel.sponsor.length > 3
                              ? 3
                              : _eventDetailsModel.sponsor.length,
                    ),
                  )),
          _eventDetailsModel.sponsor == null ||
                  _eventDetailsModel.sponsor.length <= 0
              ? Container()
              : Container(
                  height: 2.0,
                  color: Colors.grey,
                ),

          //SpeakerSection
          _eventDetailsModel.speaker == null ||
                  _eventDetailsModel.speaker.length <= 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "SPEAKERS",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => SpeakersList(
                              listSpeaker: _eventDetailsModel.speaker),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "View All",
                                style: TextStyle(
                                    color: Color(0xffc00e34),
                                    fontWeight: FontWeight.w600),
                              ))),
                    )
                  ],
                ),
          _eventDetailsModel.speaker == null ||
                  _eventDetailsModel.speaker.length <= 0
              ? Container()
              : Container(
                  height: 150.0,
                  child: Center(
                    child: new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return new SpeakerWidget(
                          speaker: _eventDetailsModel.speaker[index],
                          eventId: eId,
                        );
                      },
                      itemCount: _eventDetailsModel.speaker == null
                          ? 0
                          : _eventDetailsModel.speaker.length > 3
                              ? 3
                              : _eventDetailsModel.speaker.length,
                    ),
                  )),

          _eventDetailsModel.speaker == null ||
                  _eventDetailsModel.speaker.length <= 0
              ? Container()
              : Container(
                  height: 2.0,
                  color: Colors.grey,
                ),
          //ateendess section
          _eventDetailsModel.attendess == null ||
                  _eventDetailsModel.attendess.length <= 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ATTENDEES",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => AttendeesList(
                              listAttendees: _eventDetailsModel.attendess),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("View All",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontWeight: FontWeight.w600)))),
                    )
                  ],
                ),
          _eventDetailsModel.attendess == null ||
                  _eventDetailsModel.attendess.length <= 0
              ? Container()
              : Container(
                  height: 150.0,
                  child: Center(
                    child: new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return new AttendessWidget(
                          attendess: _eventDetailsModel.attendess[index],
                        );
                      },
                      itemCount: _eventDetailsModel.attendess == null
                          ? 0
                          : _eventDetailsModel.attendess.length > 3
                              ? 3
                              : _eventDetailsModel.attendess.length,
                    ),
                  )),

          _eventDetailsModel.attendess == null ||
                  _eventDetailsModel.attendess.length <= 0
              ? Container()
              : Container(
                  height: 2.0,
                  color: Colors.grey,
                ),
          //exhibitorSection
          _eventDetailsModel.exhibitor == null ||
                  _eventDetailsModel.exhibitor.length <= 0
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "EXHIBITORS",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => ExhibitorList(
                              listExhibitor: _eventDetailsModel.exhibitor),
                        );
                        Navigator.of(context).push(route);
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("View All",
                                  style: TextStyle(
                                      color: Color(0xffc00e34),
                                      fontWeight: FontWeight.w600)))),
                    )
                  ],
                ),
          _eventDetailsModel.exhibitor == null ||
                  _eventDetailsModel.exhibitor.length <= 0
              ? Container()
              : Container(
                  height: 150.0,
                  child: Center(
                    child: new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return new ExhibitorWidget(
                          exhibitor: _eventDetailsModel.exhibitor[index],
                        );
                      },
                      itemCount: _eventDetailsModel.exhibitor == null
                          ? 0
                          : _eventDetailsModel.exhibitor.length > 3
                              ? 3
                              : _eventDetailsModel.exhibitor.length,
                    ),
                  )),
        ],
      ))
    ]);
  }

  Container Venue() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 30.0, right: 25.0),
            child: Text(
              _eventDetailsModel.event == null
                  ? ""
                  : _eventDetailsModel.event.building,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 3.0, right: 25.0),
            child: Text(
              _eventDetailsModel.event == null
                  ? ""
                  : "Floor No: " + _eventDetailsModel.event.floor,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 3.0, right: 25.0),
            child: Text(
              _eventDetailsModel.event == null
                  ? ""
                  : "Room No: " + _eventDetailsModel.event.room,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 3.0, right: 25.0),
            child: Text(
              _eventDetailsModel.event == null
                  ? ""
                  : _eventDetailsModel.event.location,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                "Navigation",
                style: TextStyle(color: Color(0xffc00e34), fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: InkWell(
                  onTap: () =>
                      _launchMap(context, _eventDetailsModel.event.location),
                  child: Icon(
                    MdiIcons.googleMaps,
                    color: Color(0xffc00e34),
                    size: 30.0,
                  )),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(15.0),
          height: 2.0,
          color: Colors.grey,
        )
      ],
    ));
  }

  _launchMap(BuildContext context, String location) async {
    var url = '';
    var encoded = Uri.encodeFull(location);
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=$encoded";
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$encoded';
      url = "comgooglemaps://?saddr=&daddr=$encoded&directionsmode=driving";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      throw 'Could not launch $url';
    }
  }

  Container Gallery() {
    bool limit = false;
    bool empty = true;
    return empty
        ? Container(
            color: Colors.white,
            child: Center(
                child: Image.asset(
              "image/upload.jpg",
              width: 250,
              height: 250,
            )
//            Text("Comming Soon..",style: TextStyle(color: Color(0xffc00e34),fontSize: 18.0),),
                ),
          )
        : Container(
            child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: List.generate(limit ? 0 : 10, (index) {
              return InkWell(
                onTap: () {
                  showGallery();
                },
                child: new Container(
                    margin: new EdgeInsets.all(5.0),
                    child:
//                  limit?
                        Image.asset(
                      "image/event.jpeg",
                      fit: BoxFit.fill,
                    ),
//                  image(index),
                    decoration: new BoxDecoration(
                        color: Colors.black38,
                        border: new Border.all(
                            color: Colors.black, style: BorderStyle.solid))),
              );
            }),
          ));
  }

  showGallery() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(),
            ));
  }

  Widget GoalEvent() {
    return Column(children: <Widget>[
      Align(
        alignment: Alignment.bottomRight,
        child: isEdit
            ? InkWell(
                child: Icon(
                  MdiIcons.check,
                  color: Colors.black54,
                ),
                onTap: () {
                  setState(() {
                    isEdit = false;
                  });
                },
              )
            : InkWell(
                child: Icon(
                  MdiIcons.pencil,
                  color: Colors.black54,
                ),
                onTap: () {
                  setState(() {
                    isEdit = true;
                  });
                  //_editGoal();
                },
              ),
      ),
      isEdit
          ? Expanded(
              child: TextFormField(
                controller: _textEditingControllerGoal,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
      Expanded(
          child: Align(
        alignment: Alignment.bottomLeft,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildTextComposer(),
              ),
            ),
            new Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ))
    ]);
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration(
                      hintText: "Expectation from event....",
                      fillColor: Colors.grey[200],
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(90.0))),
//                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => debugPrint(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
      ),
      onPressed: _isComposingMessage
          ? () => debugPrint(_textEditingController.text)
          : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    print(messageText);
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _controller.index;
    if (_activeTabIndex == 1) {
      setState(() {
        pinned = true;
      });
    } else {
      setState(() {
        pinned = true;
      });
    }
    print(_activeTabIndex);
  }

  _getEvent() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var url = Config.event_info + "$eId";
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
          _eventDetailsModel = EventDetailsModel.fromJson(response);
        });
        if (_eventDetailsModel.status) {
          setState(() {});
          if (_eventDetailsModel.attendess.length > 0) {
            for (int i = 0; i < _eventDetailsModel.attendess.length; i++) {
              if (_eventDetailsModel.attendess[i].sId == UserId) {
                setState(() {
                  isInterested = true;
                });
              }
            }
          }
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_eventDetailsModel.message),
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

  void getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var Id = await this.sharedPreferences.get('id');
    setState(() {
      UserId = Id;
    });

    print("user: $UserId");
  }

  _getSession() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var url = Config.event_session + "$eId";
      print(url);
      final response = await Services(url).getMethod(context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('Server error'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _sessionModel = SessionModel.fromJson(response);
        });
        if (_sessionModel.status) {
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Color(0xffc00e34),
            content: Text(_sessionModel.message),
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

class AttendessWidget extends StatelessWidget {
  final Attendess attendess;
  const AttendessWidget({Key key, this.attendess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              var route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    AttendessD(attendess: attendess),
              );
              Navigator.of(context).push(route);
            },
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(
                    (MediaQuery.of(context).size.width * .25) / 2),
                border: new Border.all(
                  width: 2.0,
                  color: Colors.grey,
                ),
              ),
              child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(
                    (MediaQuery.of(context).size.width * .25) / 2,
                  ),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * .25,
                    height: MediaQuery.of(context).size.width * .25,
                    placeholder: new AssetImage(
                      'image/usernew.png',
                    ),
                    image: NetworkImage(
                      Config.imageBaseurl + "users/${attendess.image}",
                    ),
                  )),
            )),
      ),
    );
  }
}

class SpeakerWidget extends StatelessWidget {
  final Speaker speaker;
  final String eventId;
  const SpeakerWidget({Key key, this.speaker, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) => Speakers(
                    speaker: speaker,
                    eventId: eventId,
                  ),
            );
            Navigator.of(context).push(route);
          },
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(
                  (MediaQuery.of(context).size.width * .25) / 2),
              border: new Border.all(
                width: 2.0,
                color: Colors.grey,
              ),
            ),
            child: new ClipRRect(
                borderRadius: new BorderRadius.circular(
                  (MediaQuery.of(context).size.width * .25) / 2,
                ),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * .25,
                  height: MediaQuery.of(context).size.width * .25,
                  placeholder: new AssetImage(
                    'image/usernew.png',
                  ),
                  image: NetworkImage(
                    Config.imageBaseurl + "users/${speaker.image}",
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class ExhibitorWidget extends StatelessWidget {
  final Exhibitor exhibitor;
  const ExhibitorWidget({Key key, this.exhibitor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  Exhibitors(exhibitor: exhibitor),
            );
            Navigator.of(context).push(route);
          },
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(
                  (MediaQuery.of(context).size.width * .25) / 2),
              border: new Border.all(
                width: 2.0,
                color: Colors.grey,
              ),
            ),
            child: new ClipRRect(
                borderRadius: new BorderRadius.circular(
                    (MediaQuery.of(context).size.width * .25) / 2),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * .25,
                  height: MediaQuery.of(context).size.width * .25,
                  placeholder: new AssetImage(
                    'image/usernew.png',
                  ),
                  image: NetworkImage(
                    Config.imageBaseurl + "exhibitors/${exhibitor.image}",
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class SponserWidget extends StatelessWidget {
  final Sponsor sponsor;
  const SponserWidget({Key key, this.sponsor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext context) => Sponser(sponsor: sponsor),
            );
            Navigator.of(context).push(route);
          },
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(00.0),
              border: new Border.all(
                width: 1.0,
                color: Colors.black,
              ),
            ),
            child: new ClipRRect(
                borderRadius: new BorderRadius.circular(
                  00.0,
                ),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * .25,
                  height: 50,
                  placeholder: new AssetImage(
                    'image/company.png',
                  ),
                  image: NetworkImage(
                      Config.imageBaseurl + "sponsers/${sponsor.image}"),
                )),
          ),
        ),
      ),
    );
  }
}
