import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool image = true;
  bool _image = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "image/Login_screen.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Form(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                          child: image
                              ? InkWell(
                                  onTap: _showImageDialog,
                                  child: new Container(
                                    height: 150.0,
                                    width: 150.0,
                                    padding: const EdgeInsets.all(20.0),
                                    //I used some padding without fixed width and height
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        // You can use like this way or like the below line
                                        //borderRadius: new BorderRadius.circular(30.0),
                                        border: Border.all(
                                            width: 3, color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(75.0)),
                                    child: _image
                                        ? Icon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.grey,
                                            size: 50.0,
                                          )
                                        : new Container(
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

                                    // You can add a Icon instead of text also, like below.
                                    //child: new Icon(Icons.arrow_forward, size: 50.0, color: Colors.black38)),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: <Widget>[
                                      new PhysicalModel(
                                        color: Colors.transparent,
                                        child: new Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                    "image/logo.png")),
                                            borderRadius:
                                                new BorderRadius.circular(50.0),
                                            border: new Border.all(
                                              width: 5.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.camera,
                                        size: 30.0,
                                      )
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "First name*",
                              hintStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Last name*",
                              hintStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Email Id*",
                              hintStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Phone No*",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Company name",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Designation",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              hintText: "Industry",
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          maxLines: 4,
                          decoration: new InputDecoration(
                              hintText: "Brife Description",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonTheme(
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("/homepage");
                              },
                              color: Colors.black,
                              child: new Text(
                                'SIGN UP',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("/login");
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ),
        )
      ],
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
                  // getImage();
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  //takeImage();
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
}
