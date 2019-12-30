import 'package:flutter/material.dart';

class ChatMessageListItem extends StatelessWidget {
  final String messageSnapshot;
  final Animation animation;
  var currentUserEmail='user';

  ChatMessageListItem({this.messageSnapshot, this.animation,this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: currentUserEmail != 'user'
            ? getSentMessageLayout()
            : getReceivedMessageLayout(),
      ),
    );
  }
  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text("me",
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(left:50.0),
              child: new Container(
                decoration: BoxDecoration(
                    color: Color(0xffc00e34),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))

                ),
                margin: const EdgeInsets.only(top: 5.0),
                child:
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(messageSnapshot,style: TextStyle(

                  ),),
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
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
               child: new ClipRRect(
    borderRadius: new BorderRadius.circular(20.0,),
    child: FadeInImage(
    width: 40,
    height: 40,
    placeholder: new AssetImage('image/company.png',),
    image: NetworkImage('https://qodebrisbane.com/wp-content/uploads/2019/07/This-is-not-a-person-2-1.jpeg',),
    )
    )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: new CircleAvatar(
                  backgroundImage:
                  new AssetImage("image/logo.png"),
                )),
          ],
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot,
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot!= null
                  ?
                  new Text(messageSnapshot,style: TextStyle(color: Colors.black),):
              new Image.asset(
                "image/logo.png",
                width: 250.0,
              )

            ),
          ],
        ),
      ),
    ];
  }
}
