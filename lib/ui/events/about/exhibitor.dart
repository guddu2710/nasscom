import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/model/detailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Exhibitors extends StatefulWidget {
  Exhibitor exhibitor;
  String route;
  Exhibitors({Key key, this.exhibitor, this.route}) : super(key: key);
  @override
  _ExhibitorState createState() => _ExhibitorState();
}

class _ExhibitorState extends State<Exhibitors> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Exhibitor _exhibitor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _exhibitor = widget.exhibitor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(_exhibitor == null ? "" : _exhibitor.firstName),
      ),
      body: Container(
        color: Colors.white,
        child: ExhibitorDetails(),
      ),
    );
  }

  Container ExhibitorDetails() {
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
                              "exhibitors/" +
                              _exhibitor.image))),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(_exhibitor == null ? "" : _exhibitor.firstName)),
          ),
          Align(alignment: Alignment.center, child: Text("")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: Colors.red[800],
                    content: Text('FaceBook not Connected'),
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
                _exhibitor == null ? "" : _exhibitor.description,
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
