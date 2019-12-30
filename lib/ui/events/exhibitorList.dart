import 'package:event_management/service/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'about/exhibitor.dart';
import 'model/detailsmodel.dart';

class ExhibitorList extends StatefulWidget {
  List<Exhibitor> listExhibitor;
  String route;
  ExhibitorList({Key key, this.listExhibitor, this.route}) : super(key: key);
  @override
  _ExhibitorListState createState() => _ExhibitorListState();
}

class _ExhibitorListState extends State<ExhibitorList> {
  List<Exhibitor> listExhibitor;
  @override
  void initState() {
    listExhibitor = widget.listExhibitor;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exhibitor"),
      ),
      body: Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new ExhibitorWidget(
              exhibitor: listExhibitor[index],
            );
          },
          itemCount: listExhibitor.length < 0 ? 0 : listExhibitor.length,
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
    return new Container(
      decoration: new BoxDecoration(
          border: new Border.all(width: 1.0, color: Colors.grey),
          color: Colors.white70),
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListTile(
        onTap: () {
          var route = MaterialPageRoute(
            builder: (BuildContext context) => Exhibitors(exhibitor: exhibitor),
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
                  'image/images_women.jpeg',
                ),
                image: NetworkImage(
                  Config.imageBaseurl + "exhibitors/" + exhibitor.image,
                ),
              )),
        ),
        title: new Text(
          exhibitor.firstName,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
