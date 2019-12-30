import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _image=false;
  bool image=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset : false,
      resizeToAvoidBottomPadding:false,
      appBar: AppBar(title:Text("Profile"),),
      body: Container(
        color: Colors.white,
        child:Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Center(
                    child: image?
                    InkWell(
                      onTap:_showImageDialog,
                      child:
                      new Container(
                        height: 150.0,
                        width: 150.0,
                        padding: const EdgeInsets.all(20.0),
                        //I used some padding without fixed width and height
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            // You can use like this way or like the below line
                            //borderRadius: new BorderRadius.circular(30.0),
                            border: Border.all(width: 3,
                                color: Colors.grey),
                            borderRadius: BorderRadius.circular(75.0)
                        ),
                        child:_image?
                        Icon(FontAwesomeIcons.camera,
                          color: Colors.grey,
                          size: 50.0,)
                            :
                        new Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
//                                      image: new DecorationImage(
//                                          fit: BoxFit.fill,
//                                          image: new FileImage(
//                                              _image)
//                                      )
                            )),
                        //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                      ),)
                        :
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment:Alignment.bottomRight,
                        children: <Widget>[
                          new PhysicalModel(
                            color: Colors.transparent,
                            child: new Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new AssetImage(
                                        "image/event.jpeg")
                                ),
                                borderRadius: new BorderRadius.circular(75.0),
                                border: new Border.all(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _showImageDialog,
                              child: Icon(MdiIcons.camera,size: 40.0,color: Colors.red[800],))
                        ],),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("User name", style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,

                      ),),
                    ],
                  ),
                  new Divider(color: Colors.grey[600],),
                  SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("First name", style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () =>
                                showFirstname()
                            ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color: Colors.grey,)),
                      )

                    ],
                  ),
                  new Divider(color: Colors.grey[600]),
                  SizedBox(height: 15.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Last name", style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,

                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () =>
                                showLastname()
                            ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color: Colors.grey,)),
                      )

                    ],
                  ),
                  new Divider(color: Colors.grey[600]),
                  SizedBox(height: 15.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Designstion", style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,

                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () =>
                                showDesignation()
                            ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color: Colors.grey,)),
                      )

                    ],
                  ),
                  new Divider(color: Colors.grey[600]),
                  SizedBox(height: 15.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Company name", style: TextStyle(
                        fontSize: 18.0,

                        color: Colors.grey,

                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () {
                              showCompany();
//                              Navigator.of(context).push(
//                                  new MaterialPageRoute<Null>(
//                                      builder: (BuildContext context) {
//                                        return _asyncInputDialogCompany(context)
//                                        ;
//                                      },
//                                      fullscreenDialog: true
//                                  ));
                            }
                            ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color: Colors.grey,)),
                      )

                    ],
                  ),
                  new Divider(color: Colors.grey[600]),
                  SizedBox(height: 15.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Industry", style: TextStyle(
                        fontSize: 18.0,

                        color: Colors.grey,

                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () =>showIndustry()
                            ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color: Colors.grey,)),
                      )

                    ],
                  ),
                  new Divider(color: Colors.grey[600]),
                  SizedBox(height: 15.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Text("About User", style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red[800]
                      ),),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                            onTap: () =>
                            showAbout()                                  ,
                            child: Icon(MdiIcons.pencil, size: 15.0,color:Colors.grey,)),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "phonefgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggxcvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
                          , style: TextStyle(
                            fontSize: 18.0,

                          color: Colors.grey,

                        ),),
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ,
      ),
    );
  }
  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  //getImage();
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  //takeImage();

                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }
  showFirstname(){
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child:Container(color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                        child: Container(
                          child:
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("Text 1"),
                              SizedBox(height: 20.0,),
                              Expanded(
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 2,
                                  keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                  //initialValue: name,
                                  decoration: new InputDecoration(
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.white
                                        )
                                    ),
                                    labelText:"First name",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ),

                              ),
                              Divider(),
                              new Expanded(
                                  child: new Align(
                                      alignment: Alignment.bottomCenter,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Update'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      )))
                            ],
                          )

                        ),
                      )
                      ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Chnage First name",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)
                  
                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
        ),
      )
  );}
  showLastname(){
    showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:Container(color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Text 1"),
                                  SizedBox(height: 20.0,),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                        labelText:"Last name",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),

                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )

                          ),
                        )
                        ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Change Last name",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)

                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
          ),
        )
    );}
  showDesignation(){
    showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:Container(color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Text 1"),
                                  SizedBox(height: 20.0,),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                        labelText:"Designation",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),

                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )

                          ),
                        )
                        ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Change Designation",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)

                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
          ),
        )
    );}
  showCompany(){
    showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:Container(color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Text 1"),
                                  SizedBox(height: 20.0,),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                        labelText:"Company Name",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),

                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )

                          ),
                        )
                        ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Change Company name",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)

                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
          ),
        )
    );}
  showIndustry(){
    showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:Container(color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Text 1"),
                                  SizedBox(height: 20.0,),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                        labelText:"Industry",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),

                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )

                          ),
                        )
                        ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Change Industry",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)

                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
          ),
        )
    );}

  showAbout(){
    showDialog(
        context: context,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:Container(color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(top:50.0,right: 30.0,left: 30.0),
                          child: Container(
                              child:
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Text 1"),
                                  SizedBox(height: 20.0,),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                        labelText:"About user",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white
                                            )
                                        ),
                                      ),
                                    ),

                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )

                          ),
                        )
                        ,)
                  ),
                  Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Icon(MdiIcons.close,size: 30.0,color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Text("Change Industry",style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),)

                  ,
                ],),
            ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
          ),
        )
    );}











}

