import 'dart:convert';

import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'chat_model.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int offset=0,limit=0,count=0;
  bool isScroll=true;
  bool issame = false;
  String PostedBy = "";
  bool _isComposingMessage = false;
  var _controller = ScrollController();
  List<MessageList> messageLists=[];
  TextEditingController _textEditingController = new TextEditingController();
  SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ChatModel _chatModel = new ChatModel();
  String name = "", image = "";
  String uId;
  UserInformations _userInformations = new UserInformations();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0){
          print("top");
        }
      // you are at top position
      else{
        if(count==50){
          setState(() {
            limit=count;
            offset=limit;
            //limit=limit+count;
          });
          _getChat(uId);

        }

        print("bottom");
        }
      // you are at bottom position
    }
    });
    _getProfiledata();
    s();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Message"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(

          children: <Widget>[
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
                  new Builder(builder: (BuildContext context) {
                    return new Container(width: 0.0, height: 0.0);
                  })
                ],
              ),
            ))),
            Expanded(
              // ListView contains a group of widgets that scroll inside the drawer
              child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return (messageLists != null ||
                          messageLists.length > 0
                          ? messageLists[index].postedBy.userType ==
                                  "user"
                              ? user(messageLists[index])
                              : admin(messageLists[index], index)
                          : Container());
                    },
                    itemCount: messageLists == null ||
                        messageLists.length <= 0
                        ? 0
                        : messageLists.length),
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

  Widget user(MessageList _user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(name==null?"":issame?"":name,style: TextStyle(fontWeight:FontWeight.w600,fontStyle: FontStyle.italic,fontSize: 18.0,),),
//
//            ),
            new Container(
                child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(
                      20.0,
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      placeholder: new AssetImage(
                        'image/usernew.png',
                      ),
                      image: NetworkImage(
                        image == null
                            ? ""
                            : Config.imageBaseurl + "users/" + image,
                      ),
                    ))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: new Container(
                decoration: BoxDecoration(
                    color: Color(0xffdb384d),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                margin: const EdgeInsets.only(top: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    _user.messageBody == null ? "" : _user.messageBody,
                    style: TextStyle(color: Colors.white),
                  ),
                )
//              messageSnapshot != null
//                  ? new Image.asset(
//                "image/logo.png",
//                width: 250.0,
//              )
//                  : new Text(messageSnapshot),
                ),
          ),
        ),
      ],
    );
  }

  Widget admin(MessageList admin, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            new Container(
                child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(
                      20.0,
                    ),
                    child: FadeInImage(
                      width: 40,
                      height: 40,
                      placeholder: new AssetImage(
                        'image/admin_new.jpeg',
                      ),
                      image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQgPgWDF2V3pKonw1OE1FwyAOj75ngF8a8fW6OFfhMcdvDRyLft",
                      ),
                    ))),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(admin.postedBy==null?"Admin":_chatModel.messageList[index].postedBy.userType=="admin"?"":admin.postedBy.name,style: TextStyle(fontWeight:FontWeight.w600,fontStyle: FontStyle.italic,fontSize: 18.0),),
//            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 70.0),
          child: new Container(
              decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              margin: const EdgeInsets.only(top: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  admin.messageBody != null ? admin.messageBody : "",
                  style: TextStyle(),
                ),
              )
//              messageSnapshot != null
//                  ? new Image.asset(
//                "image/logo.png",
//                width: 250.0,
//              )
//                  : new Text(messageSnapshot),
              ),
        ),
      ],
    );
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
                  maxLength: 50,
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                      if (messageText.length == 120) {
                        return "Max length is 120";
                      }
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration(
                      counterText: "",
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
          ? () => _postChat(uId, _textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
      ),
      onPressed: _isComposingMessage
          ? () => _postChat(uId, _textEditingController.text)
          : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    // _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
    // _postChat(uId,text);

    //_sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    // _postChat(uId);
    print(messageText);
  }

  void s() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("id");
    setState(() {
      uId = id;
    });
    _getChat(id);
  }

  _getChat(id) async {
    try {
      var url = Config.get_messages;
      print(id);
      print("offset=$offset");
      var formData = {
        "user_id": id,
        "offset":offset
      };
      final response =
          await Services(url).postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
      } else {
        setState(() {
          _chatModel = ChatModel.fromJson(response);
          count=_chatModel.messageList.length;
          //limit=count;
          messageLists.addAll(_chatModel.messageList);
          print("count=$count");
          print("limit=$limit");
        });
        if (_chatModel.status) {
          setState(() {
            if(offset==0) {
              sharedPreferences.setString("mId",
                  _chatModel.messageList[0].id);
            }
          });
          print("id+++" +
              _chatModel.messageList[0].id);
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red[800],
            content: Text(_chatModel.message),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (e) {
      print(e.toString());
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }

  void _getProfiledata() async {
    print("skdfn");
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      print(sharedPreferences.getKeys());
      final data = sharedPreferences.get('userdetails');
      final json1 = JsonDecoder().convert(data);
      print(json1);
      setState(() {
        image = sharedPreferences.get('profile_pic');
        _userInformations = UserInformations.fromJson(json1);
        name = _userInformations.firstName;
        print(name);
      });

      // print(_userInformations.designation);
    } catch (e) {
      Toast.show(
        "Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
    // email=json1['']
//    phone=email=sharedPreferences.get('phone');
//    name=email=sharedPreferences.get('name');
  }

  _postChat(id, text) async {
    try {
      var url = Config.post_messages;
      print(id);
      var formData = {"user_id": id, "message_body": text};
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
          var data = ChatSentModel.fromJson(response);
          if (data.status) {
            setState(() {
              _isComposingMessage = false;
              _textEditingController.text = "";
              offset=0;
              messageLists.clear();
            });
            _getChat(id);
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

      Toast.show(
        "product Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }
}

class ChatSentModel {
  String message;
  bool status;

  ChatSentModel({this.message, this.status});

  ChatSentModel.fromJson(Map<String, dynamic> json) {
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
