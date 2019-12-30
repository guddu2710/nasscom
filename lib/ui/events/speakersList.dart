import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/about/speaker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

import 'model/detailsmodel.dart';

class SpeakersList extends StatefulWidget {
  List<Speaker> listSpeaker;
  String route;
  String eventId;
  SpeakersList({Key key, this.listSpeaker, this.route, this.eventId})
      : super(key: key);
  @override
  _SpeakersListState createState() => _SpeakersListState();
}

class _SpeakersListState extends State<SpeakersList> {
  List<Speaker> listSpeaker;
  String eventId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSpeaker = widget.listSpeaker;
    print(listSpeaker.length);
    eventId = widget.eventId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speaker"),
      ),
      body: Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new SpeakersWidget(
              speaker: listSpeaker[index],
              eID: eventId,
            );
          },
          itemCount: listSpeaker.length < 0 ? 0 : listSpeaker.length,
        ),
      ),
    );
  }
}

class SpeakersWidget extends StatelessWidget {
  final Speaker speaker;
  final String eID;
  const SpeakersWidget({Key key, this.speaker, this.eID}) : super(key: key);

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
        onTap: () {
          var route = MaterialPageRoute(
            builder: (BuildContext context) => Speakers(
                  speaker: speaker,
                  eventId: eID,
                ),
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
                  'image/usernew.png',
                ),
                image: NetworkImage(
                  speaker.image == null
                      ? ""
                      : Config.imageBaseurl + "users/" + speaker.image,
                ),
              )),
        ),
//        new FadeInImage(
//          placeholder: new AssetImage('image/logo.png'),
//          image: AssetImage('image/logo.png'),
//        ),
        title: new Text(
          speaker.userInformations.firstName.toString().isEmpty
              ? ""
              : speaker.userInformations.firstName +
                  " " +
                  speaker.userInformations.lastName,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
