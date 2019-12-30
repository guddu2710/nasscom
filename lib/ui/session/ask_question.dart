import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'Askquestion_model.dart';

class Askquestion extends StatefulWidget {
  String speakerId;
  String eventId;
  Askquestion({Key key, this.speakerId, this.eventId}) : super(key: key);
  @override
  _AskquestionState createState() => _AskquestionState();
}

class _AskquestionState extends State<Askquestion> {
  ScrollController _scrollController = new ScrollController();

  String speakerId, eventId;
  bool _isComposingMessage = false;
  TextEditingController _textEditingController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AskQuestion askQuestion = new AskQuestion();
  List<Data> data;
  String text = "";
  int maxLenght = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.text = text;
    speakerId = widget.speakerId;
    eventId = widget.eventId;
    _getQuestion(speakerId, eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("ASK QUESTION"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              // ListView contains a group of widgets that scroll inside the drawer
              child: Container(
                child: new ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return new QuestionWidget(
                        data: data[index],
                      );
                    },
                    itemCount:
                        askQuestion.data == null || askQuestion.data.length <= 0
                            ? 0
                            : askQuestion.data.length),
              ),
            ),

            // This container holds the align
            Container(
                // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
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
                    )))
          ],
        ));
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
              //getSentMessageLayout(),

              new Expanded(
                child: new TextField(
                  minLines: 1,
                  maxLines: 5,
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration(
                      hintText: "Type a message",
                      fillColor: Colors.grey[200],
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0)))),
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
          ? () => _postQuestion(eventId, speakerId, _textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
      ),
      onPressed: _isComposingMessage
          ? () => _postQuestion(eventId, speakerId, _textEditingController.text)
          : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    print(messageText);
  }

  _postQuestion(id, text, question) async {
    try {
      var url = Config.ask_question;
      print(id);
      var formData = {"event_id": id, "speaker_id": text, "question": question};
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
          askQuestion = AskQuestion.fromJson(response);
          if (askQuestion.status) {
            setState(() {
              _isComposingMessage = false;
              _textEditingController.text = "";
            });
            _getQuestion(text, id);
          } else {
            Toast.show(
              "Tray Again",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
            );
          }
        });
      }
    } catch (e) {
      print(e.toString());

//      setState(() {
//      //  _isloading = false;
//      });
      Toast.show(
        " Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  _getQuestion(sId, eId) async {
    try {
      var url = Config.ask_question_permit;
      var formData = {"event_id": eId, "speaker_id": sId};
      final response =
          await Services(url).postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Text("server error"),
          duration: Duration(seconds: 2),
        ));
      } else {
        setState(() {
          askQuestion = AskQuestion.fromJson(response);
        });
        if (askQuestion.status) {
          setState(() {
            data = askQuestion.data;
            //   _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        } else {
          Toast.show(
            "Tray Again",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        }
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
}

class QuestionWidget extends StatelessWidget {
  final Data data;
  const QuestionWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              new PhysicalModel(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: new Container(
                      margin: new EdgeInsets.symmetric(vertical: 6.0),
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 20.0, top: 5.0, bottom: 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    data.name == null ? "" : data.name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    data.question == null ? "" : data.question,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0)),
                          border:
                              new Border.all(width: 2.0, color: Colors.black),
                          color: Colors.white70)),
                ),
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: data.image != null
                          ? NetworkImage(data.image == null
                              ? ""
                              : Config.imageBaseurl + "users/" + data.image)
                          : new AssetImage("image/usernew.png")),
                  borderRadius: new BorderRadius.circular(75.0),
                  border: new Border.all(
                    width: 2.0,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
