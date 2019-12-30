import 'package:event_management/service/config.dart';
import 'package:event_management/ui/events/model/session_model.dart';
import 'package:event_management/util/read_more_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:expandable/expandable.dart';
class SessionDetails extends StatefulWidget {
  List<String> images;
  SessionTitle sessionDetails;
  SessionDetails({Key key, this.images, this.sessionDetails}) : super(key: key);
  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> with TickerProviderStateMixin {
  TextEditingController _textEditingController= new TextEditingController();
  TabController _controller;
  SessionTitle sessionDetails;
  bool _isComposingMessage = false;
  List<String> name=["Payel Debnath","Razak Ahamed",'Sukanya Chakraborty'];
  List<String> image=["https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQYlDTKr8xtAQjuLS9hLH8JM0b22M_MGnCjNtLNhd7TtkImw8mJ",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSy12wRmM02asV3BlKty27ir8l0OhFn16ySyHIgpTjXFBkKKucQ",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRTPALbjk8Ag8af2vuVAANQYgDfJrOwei_AvLnnwCPzBT_8ld1S"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionDetails=widget.sessionDetails;
    _controller = new TabController(vsync: this, initialIndex: 0, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                  primary: true,
                  floating: true,
                  pinned: true,
                  title: Text(sessionDetails.sessionTitle==null?"":sessionDetails.sessionTitle),
                  bottom:
                  PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Colors.black),
                      child: Container(
                        color: Colors.white,
                        height: 48.0,
                        alignment: Alignment.center,
                        child:
                        TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 5.0,color: Colors.red[800]),
                          ),
                          labelPadding: EdgeInsets.zero,
                          controller: _controller,
                          onTap: (index)=>debugPrint("$index"),
                          tabs: <Widget>[
                            Tab(child: Image.asset("image/Speaker.png",height: 25.0,width: 25.0,)),
                            Tab(child: Icon(MdiIcons.mapMarker,color:Colors.black54,size: 25.0,)),
                            Tab(child: Icon(MdiIcons.image,color:Colors.black45,size: 25.0,)),
                            Tab(child: Icon(MdiIcons.bullseyeArrow,color:Colors.black45,size: 25.0,)),
                          ],
                        ),
                      ),
                    ),)
//                TabBar(
//                  indicatorColor: _activeColor,
//                  labelPadding: EdgeInsets.zero,
//                  controller: _controller,
//                  tabs: _tabs,
//                ),
              ),

            ];
          },
          body: TabBarView(
            controller: _controller,
            children: <Widget>[
              Container(
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: SessionDetails(),
                ),
              ),
              Container(
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Venue(),
                ),
              ),
              Container(
                color: Colors.white,
                child: Gallery(),
              ),
              Container(
                color: Colors.white,
                child: GoalEvent(),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget SessionDetails() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top:8.0),
                  child:
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("About the Event",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w500,fontSize: 18.0),)),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child:
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(MdiIcons.heart,color: Colors.white,)
                            ),)
                        ],),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReadMoreText(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ',
                          style: TextStyle(color: Colors.grey[600]),
                          trimLines: 4,
                          textAlign: TextAlign.justify,
                          colorClickableText: Colors.red,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Read more',
                          trimExpandedText: ' Less',
                        ),
                      ),
                      Divider(color: Colors.grey,)
                    ],
                  ),
                  //Text("Promotions",style: TextStyle(color: Colors.red[800],fontSize: 20.0,fontWeight: FontWeight.w600),),
                ),),
            ],
          ),
        ),
        SliverList(delegate: SliverChildBuilderDelegate((builder,index){
          return SessionWidget( speakerss:sessionDetails.speaker[index]);
        },childCount: name.length)),
      ],
    );
  }
  Container Venue() {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 30.0, right: 25.0),
                child: Text(
                  "Openweb Solutions",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 3.0, right: 25.0),
                child: Text(
                  "Floor No:3",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 3.0, right: 25.0),
                child: Text(

                  "Room No:12",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.all(15.0),
              height: 2.0,
              color: Colors.grey,
            )
          ],
        ));
  }
  Container Gallery() {
    bool limit=false;
    bool empty=true;
    return empty?
    Container(
      child: Center(
          child: Image.asset(
            "image/Coming_Soon.jpg",
            width: 250,
            height: 250,
          )
//            Text("Comming Soon..",style: TextStyle(color: Color(0xffc00e34),fontSize: 18.0),),
      ),
    ):
    Container(
        child: GridView.count(
          crossAxisCount:2,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children:
          List.generate(limit? 0:10, (index) {
            return new Container(
                margin: new EdgeInsets.all(5.0),
                child:
//                  limit?
                Image.asset("image/event.jpeg",fit: BoxFit.fill,),
//                  image(index),
                decoration:
                new BoxDecoration(color: Colors.black38, border: new Border.all(color: Colors.black,style:BorderStyle.solid ))
            )
            ;
          }
          ),
        )
    );
  }
  Widget GoalEvent() {
    return Column(
        children: <Widget>[
          Align(alignment: Alignment.bottomRight,child:

          InkWell(child:Icon(MdiIcons.pencil,color: Colors.black54,) ,onTap: (){
//            _editGoal();
          },)
            ,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.justify,),

          ),

          Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListView(
                  shrinkWrap:true,
                  children: <Widget>[
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
                      return new Container(width: 0.0, height: 0.0);
                    })
                  ],
                ),
              ))
        ]);
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
                      hintText: "Expectation from event....",
                      fillColor: Colors.grey[200],
                      hintStyle: TextStyle(
                        color: Colors.black54,
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
class SessionWidget extends StatelessWidget {
  final Speakerss speakerss;
  const SessionWidget({Key key, this.speakerss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(right:15.0,bottom: 7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(
                        (MediaQuery.of(context).size.width * .25) / 4),
                    border: new Border.all(
                      width: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(
                          (MediaQuery.of(context).size.width * .25) / 4),
                      child:
                      FadeInImage(
                        fit: BoxFit.cover,
                        width: (MediaQuery.of(context).size.width * .25)/2,
                        height: (MediaQuery.of(context).size.width * .25)/2,
                        placeholder: new AssetImage(
                          'image/mens.jpeg',
                        ),
                        image: NetworkImage(speakerss.image==null?"":Config.imageBaseurl+ "users/"+speakerss.image),
                      )),
                ),
                SizedBox(width: 10.0,),
                Flexible(
                  child:   ExpandablePanel(
                    header: Text(speakerss.userInformations.firstName==null?"":speakerss.userInformations.firstName+"" +speakerss.userInformations.lastName+"\n"+speakerss.userInformations.designation==null?"":speakerss.userInformations.designation,
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                    ),
                    collapsed: Text(speakerss.userInformations.about==null?"":speakerss.userInformations.about,textAlign:TextAlign.justify,softWrap: true,maxLines:2,style: TextStyle(color: Colors.black54),  ),
                    expanded: Text(speakerss.userInformations.about==null?"":speakerss.userInformations.about , textAlign:TextAlign.justify,softWrap: true,style: TextStyle(color: Colors.black54), ),
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: true,




                  ),
                ),
              ],
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.white10,
              border: new Border(
                  bottom: BorderSide(color: Colors.grey[300],width: 1.0))
          ),
        ),
      ),
    );
  }


}