import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/about/sponser.dart';
import 'package:event_management/ui/events/model/detailsmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class SponserList extends StatefulWidget {
  List<Sponsor> listSponser;
  String route;
  SponserList({Key key, this.listSponser, this.route}) : super(key: key);

  @override
  _SponserListState createState() => _SponserListState();
}

class _SponserListState extends State<SponserList> {
  List<Sponsor> listSponser;
  @override
  void initState() {
    listSponser=widget.listSponser;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sponsers"),),
      body: Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new SponserWidget(
              sponser: listSponser[index],
            );
          },
          itemCount: listSponser.length<=0?0:listSponser.length,
        ),
      ),
    );
  }
}
class SponserWidget extends StatelessWidget {
  final Sponsor sponser;
  const SponserWidget({Key key, this.sponser}) : super(key: key);

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
        onTap: (){
          var route = MaterialPageRoute(builder: (BuildContext context) =>
              Sponser(sponsor:sponser),
          );
          Navigator.of(context).push(route);
          },
        leading:
        Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(
               25.0),
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
                  Config.imageBaseurl+ "sponsers/"+sponser.image,
                ),
              )),
        ),
        title: new Text(sponser.firstName,style: TextStyle(color: Colors.black),),

      ),
    );
  }
}