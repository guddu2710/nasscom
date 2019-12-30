import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/events/model/detailsmodel.dart';
import 'package:event_management/ui/session/Askquestion_model.dart';
import 'package:event_management/ui/session/ask_question.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
class Speakers extends StatefulWidget {
  Speaker speaker;
  String eventId;
  String route;
  Speakers({Key key, this.speaker, this.route,this.eventId}) : super(key: key);
  @override
  _SpeakersState createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Speaker speaker;
  String eventId;
  AskQuestion askQuestion=new AskQuestion();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speaker = widget.speaker;
    eventId=widget.eventId;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset : false,
      resizeToAvoidBottomPadding:false,
      appBar: AppBar(title:
      Text(speaker==null?"":speaker.userInformations.firstName+" "+speaker.userInformations.lastName),),
      body: Container(
        color: Colors.white,
        child:SpeakerDetails(),
      ),
    );
  }
  Container SpeakerDetails() {
    bool _image=false;
    bool image=false;
    return Container(
      child:
      ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Align(
                alignment: Alignment.center,
                child:Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(40.0,),
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          placeholder: new AssetImage('image/speaker_giving.png',),
                          image: NetworkImage(
                              speaker.image==null?"":
                              Config.imageBaseurl + "users/" + speaker.image)
                      )
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Align(
                alignment: Alignment.center,
                child:Text(speaker==null?"":speaker.userInformations.firstName+" "+speaker.userInformations.lastName),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child:Text(speaker.userInformations.designation==null?"":"(${speaker.userInformations.designation})")
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: (){
                  speaker.userInformations.facebook==null?
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
                        content: Text('Facebook not Connected'),
                        duration: Duration(seconds: 2),
                      )):
                  _launchURL(speaker.userInformations.facebook);
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(MdiIcons.facebook,color: Colors.grey,size: 30.0,),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  speaker.userInformations.facebook==null?
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
                        content: Text('LinkedIn not Connected'),
                        duration: Duration(seconds: 2),
                      )):
                  _launchURL(speaker.userInformations.linkedin);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(MdiIcons.linkedin,color: Colors.grey,size: 30.0,),
                ),
              ),
              InkWell(
                onTap: (){
                  _getQuestion(speaker.sId,eventId);
                 // Navigator.of(context).pushNamed("/askquestion");
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(MdiIcons.commentQuestion,color: Colors.grey,size: 30.0,),
                ),
              )

            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right:10.0,left:10.0),
            child: Container(height: 2.0,color: Colors.grey,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:

            Center(
              child: Text(
              speaker.userInformations.about==null?"":speaker.userInformations.about,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.justify,),
            ),

          ),
        ],
      ),

    );
  }
  _getQuestion(sId,eId) async {
    try {
      var url = Config.ask_question_permit;
      var formData = {
        "event_id": eId,
        "speaker_id":sId
      };
      final response = await Services(url).postMethod(formData,context,_scaffoldKey);
      print(response);
      if (response == null)
      {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[800],
              content: Text("No data available"),
              duration: Duration(seconds: 2),
            ));

      } else {
        setState(() {
          askQuestion=AskQuestion.fromJson(response);
          if(askQuestion.status){
            var route = MaterialPageRoute(builder: (BuildContext context) =>
                Askquestion(speakerId:sId,eventId: eventId,),
            );
            Navigator.of(context).push(route);
          }
          else{
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(askQuestion.message),
                  duration: Duration(seconds: 2),
                ));
          }
        });

//        _chatModel=ChatModel.fromJson(response);
//        if(_chatModel.status){
//
//
//        }
//        else{
//          Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
//
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
  _launchURL(url) async {
    //   const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[800],
            content: Text('Could not launch $url'),
            duration: Duration(seconds: 2),
          ));
      throw 'Could not launch $url';
    }
  }
}
