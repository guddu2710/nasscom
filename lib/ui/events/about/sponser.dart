import 'dart:io';

import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/model/detailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

class Sponser extends StatefulWidget {
  Sponsor sponsor;
  String route;
  Sponser({Key key, this.sponsor, this.route}) : super(key: key);
  @override
  _SponserState createState() => _SponserState();
}

class _SponserState extends State<Sponser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Sponsor sponser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sponser = widget.sponsor;
    print(Config.imageBaseurl + "sponsers/" + "${sponser.image}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(sponser == null ? "" : sponser.firstName),
      ),
      body: Container(
        color: Colors.white,
        child: SponserDetails(),
      ),
    );
  }

  Container SponserDetails() {
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
                            'image/company.png',
                          ),
                          image: NetworkImage(Config.imageBaseurl +
                              "sponsers/" +
                              sponser.image))),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(sponser == null ? "" : sponser.firstName)),
          ),
          Align(alignment: Alignment.center, child: Text("")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  sponser.social.facebook == null
                      ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.red[800],
                          content: Text('Facebook not Connected'),
                          duration: Duration(seconds: 2),
                        ))
                      : _launchURL(sponser.social.facebook);
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
                  sponser.social.twitter == null
                      ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.red[800],
                          content: Text('LinkedIn not Connected'),
                          duration: Duration(seconds: 2),
                        ))
                      : _launchURL(sponser.social.twitter);
//                  _scaffoldKey.currentState.showSnackBar(
//                      SnackBar(
//                        backgroundColor:Colors.red[800] ,
//                        content: Text('LinkedIn not connected'),
//                        duration: Duration(seconds: 2),
//                      ));
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                sponser == null ? "" : sponser.description,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
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
}
