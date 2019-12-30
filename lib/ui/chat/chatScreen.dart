import 'package:event_management/ui/chat/chatMessageListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
var _scaffoldContext;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController =
  new TextEditingController();
  bool _isComposingMessage = false;
  Animation<double> animation;
  AnimationController controller;
  @override void initState() {
    super.initState();
//    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
//    animation = Tween<double>(begin: 0, end: 300).animate(controller)
//      ..addListener(() {
//        setState(() {
//          // The state that has changed here is the animation object’s value.
//        });
//      });
//    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(""),
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,

        ),
        body: new Container(
          color:Colors.white,
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: ChatMessageListItem(
                  messageSnapshot: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  currentUserEmail: "me",
                ),
              )

              ,
//              new Divider(height: 1.0,color: Colors.grey,),
              new Container(
                decoration:
                new BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextComposer(),
                ),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
                    color: Colors.grey[200],
                  )))
              : null,
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
//              new Container(
//                margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                child: new IconButton(
//                    icon: new Icon(
//                      Icons.photo_camera,
//                      color: Theme.of(context).accentColor,
//                    ),
//                    onPressed: ()  {
////                      await _ensureLoggedIn();
////                      File imageFile = await ImagePicker.pickImage();
////                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
////                      StorageReference storageReference = FirebaseStorage
////                          .instance
////                          .ref()
////                          .child("img_" + timestamp.toString() + ".jpg");
////                      StorageUploadTask uploadTask =
////                      storageReference.put(imageFile);
////                      Uri downloadUrl = (await uploadTask.future).downloadUrl;
////                      _sendMessage(
////                          messageText: null, imageUrl: downloadUrl.toString());
//                    }),
//              ),
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
              hintText: "Send a message",
              fillColor: Colors.grey[200],
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              filled: true,
              focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(90.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(90.0),
                borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(90.0)
              )
          ),
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
      icon: new Icon(Icons.send,),
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
}
