import 'dart:convert';
import 'dart:io';
import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:event_management/ui/login/password_reset.dart';
import 'package:event_management/ui/profileSettings/profile_model.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_hud/progress_hud.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _controllerFirstName = new TextEditingController();
  TextEditingController _controllerLastName = new TextEditingController();
  TextEditingController _controllerOldpass = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllernewPassword = new TextEditingController();
  TextEditingController _controllernewCPassword = new TextEditingController();
  TextEditingController _controllerCompany = new TextEditingController();
  TextEditingController _controllerIndustry = new TextEditingController();
  TextEditingController _controllerDesignation = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerFacebook = new TextEditingController();
  TextEditingController _controllerLinkedIn = new TextEditingController();
  TextEditingController _controllerAbout = new TextEditingController();
  bool _autoValidate = false;
  String profileImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  File _image;
  ProfileModel _profileModel = new ProfileModel();
  TabController _controller;
  SharedPreferences sharedPreferences;
  UserInformations _userInformations = new UserInformations();
  String email, password, line, profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getProfiledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                  floating: true,
                  pinned: true,
                  title: Text("Profile Settings"),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(accentColor: Colors.black),
                      child: Container(
                        color: Colors.white,
                        height: 48.0,
                        alignment: Alignment.center,
                        child: TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide:
                                BorderSide(width: 5.0, color: Colors.red[800]),
                          ),
                          labelPadding: EdgeInsets.zero,
                          controller: _controller,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                "Basic Details",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Contact Details",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ProfileDetails(),
                  )),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ContactDetails(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _profileImageUpdate() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      try {
        //print(_image);
        FormData formdata = new FormData(); // just like JS
        formdata.add(
            "image", new UploadFileInfo(_image, path.basename(_image.path)));
        final response = await Services(Config.profile_image)
            .postMethod(formdata, context, _scaffoldKey);
        print(response);
        setState(() {
          isLoading = false;
        });
        if (response == null) {
          setState(() {});
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('No data available'),
            duration: Duration(seconds: 3),
          ));
        } else {
          setState(() {
            _profileModel = ProfileModel.fromJson(response);
            profile = _profileModel.data.image;
          });
          sharedPreferences.setString(
              "userdetails", json.encode(_profileModel.data.userInformations));
          sharedPreferences.setString("profile_pic", _profileModel.data.image);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Toast.show(
          "Something went wrong please try again later",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    } catch (e) {}
  }

  Container ProfileDetails() {
    bool image = false;
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  new PhysicalModel(
                    color: Colors.transparent,
                    child: isLoading
                        ? Center(
                            child: Container(
                                height: 150.0,
                                width: 150.0,
                                child: CircularProgressIndicator()),
                          )
                        : new Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: profile == null || profile == ""
                                      ? new AssetImage("image/usernew.png")
                                      : new NetworkImage(Config.imageBaseurl +
                                          "users/" +
                                          profile)),
                              borderRadius: new BorderRadius.circular(75.0),
                              border: new Border.all(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  InkWell(
                      onTap: () {
                        _showMenu();
                        setState(() {
                          image = true;
                        });
                      },
                      child: Icon(
                        MdiIcons.camera,
                        size: 40.0,
                        color: Colors.red[800],
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Email",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      MdiIcons.email,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          email == null ? "User name" : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          new Divider(
            color: Colors.grey[600],
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "First Name",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.account,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.firstName == null
                              ? "First Name"
                              : _userInformations.firstName,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _controllerFirstName.text =
                              _userInformations.firstName == null
                                  ? ""
                                  : _userInformations.firstName;
                        });
                        showFirstname();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Last name",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.account,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.lastName == null
                              ? "Last Name"
                              : _userInformations.lastName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _controllerLastName.text =
                              _userInformations.lastName == null
                                  ? ""
                                  : _userInformations.lastName;
                        });
                        showLastname();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Password",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.lock,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          line == null ? "Password" : line,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () => showPassword(),
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  _showMenu() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => new AlertDialog(
            content: Wrap(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        getImage();
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.photo_album,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Choose from Gallery',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        takeImage();
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Take photo',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _image = null;
                          _removeImage();
                        });
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Remove Photo',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.close,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  takeImage() async {
    //print()
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      isLoading = true;
      _image = image;
      print(_image);
    });
    if (_image != null) {
      _profileImageUpdate();
    } else {
      isLoading = false;
    }
  }

  getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      isLoading = true;
      _image = image;
      print("image=$image");
    });
    if (_image != null) {
      _profileImageUpdate();
    } else {
      isLoading = false;
    }
  }

  Container ContactDetails() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Company",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.city,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.company == null
                              ? "Company name"
                              : _userInformations.company,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerCompany.text =
                            _userInformations.company == null
                                ? ""
                                : _userInformations.company;
                        showCompany();
//
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Industry",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.worker,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.industry == null
                              ? "Industry"
                              : _userInformations.industry,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerIndustry.text =
                            _userInformations.industry == null
                                ? ""
                                : _userInformations.industry;
                        showIndustry();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Designation",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.clipboardAccount,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.designation == null
                              ? "Designstion"
                              : _userInformations.designation,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerDesignation.text =
                            _userInformations.designation == null
                                ? ""
                                : _userInformations.designation;
                        showDesignation();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Mobile",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.cellphone,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.phoneNo == null
                              ? "Phone"
                              : _userInformations.phoneNo,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerPhone.text =
                            _userInformations.phoneNo == null
                                ? ""
                                : _userInformations.phoneNo;
                        showPhone();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "Facebook",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.facebook,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.facebook == null
                              ? "Facebook"
                              : _userInformations.facebook,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerFacebook.text =
                            _userInformations.facebook == null
                                ? ""
                                : _userInformations.facebook;
                        showFacebook();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              "LinkedIn",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Row(
                  children: <Widget>[
                    Icon(
                      MdiIcons.linkedin,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _userInformations.linkedin == null
                              ? "LinkedIn"
                              : _userInformations.linkedin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        _controllerLinkedIn.text =
                            _userInformations.linkedin == null
                                ? ""
                                : _userInformations.linkedin;
                        showLinkedIn();
                      },
                      child: Icon(
                        MdiIcons.pencil,
                        size: 20.0,
                        color: Colors.grey,
                      )),
                ),
              )
            ],
          ),
          new Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "About User",
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      _controllerAbout.text = _userInformations.about == null
                          ? ""
                          : _userInformations.about;
                      showAbout();
                    },
                    child: Icon(
                      MdiIcons.pencil,
                      size: 20.0,
                      color: Colors.grey,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  _userInformations.about == null
                      ? ""
                      : _userInformations.about,
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
    );
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
        email = sharedPreferences.get('email');
        password = sharedPreferences.get('password');
        profile = sharedPreferences.get('profile_pic');
      });
      setState(() {
        _userInformations = UserInformations.fromJson(json1);
        line = ' * ' * password.length;
      });
      print(_userInformations.designation);
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

  showFirstname() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //  new Text("Text 1",style: TextStyle(color: Colors.white70),),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      controller: _controllerFirstName,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black),
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "First name",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('CANCEL',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('DONE',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile(
                                                      "first_name",
                                                      _controllerFirstName
                                                          .text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change First name",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showLastname() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black),
                                      controller: _controllerLastName,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "Last name",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("last_name",
                                                      _controllerLastName.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Last name",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showPassword() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: new Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 50.0, right: 30.0, left: 30.0),
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //   new Text("Text 1"),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      autovalidate: _autoValidate,
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      validator: (confirmpass) {
                                        if (confirmpass != password) {
                                          return "Old doesn't match";
                                        }
                                      },
                                      keyboardType: TextInputType.text,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
                                      controller: _controllerOldpass,
                                      style: TextStyle(color: Colors.black),
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "OLD PASSWORD",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                    Divider(),
                                    TextFormField(
                                      autovalidate: _autoValidate,
                                      keyboardType: TextInputType.text,
                                      controller: _controllernewPassword,
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      validator: (confirmpass) {
                                        if (confirmpass.length == 0) {
                                          return "Please Enter new Password";
                                        } else if (confirmpass.length < 4) {
                                          return "Password length should be more than 4 character";
                                        } else if (confirmpass == password) {
                                          return " Password  match with old password";
                                        }
                                      },
                                      style: TextStyle(color: Colors.black),
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "NEW PASSWORD",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                    Divider(),
                                    Expanded(
                                      child: TextFormField(
                                        autovalidate: _autoValidate,
                                        obscureText: true,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.black),
                                        controller: _controllernewCPassword,
                                        validator: (confirmpass) {
                                          if (confirmpass.length == 0) {
                                            return "Please Enter Confirm new Password";
                                          } else if (confirmpass !=
                                              _controllernewPassword.text) {
                                            return " paassword doesn't match with new password";
                                          }
                                        },
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                        //initialValue: name,
                                        decoration: new InputDecoration(
                                          enabledBorder:
                                              new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.black)),
                                          labelText: "CONFIRM NEW PASSWORD",
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          focusedBorder:
                                              new UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    new Expanded(
                                        child: new Align(
                                            alignment: Alignment.bottomCenter,
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    'DONE',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    _validateInputs();
                                                    //_postPassword();
                                                    //  Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            )))
                                  ],
                                )),
                              ),
                            )),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  void _validateInputs() async {
    print("hi");
    if (_formKey.currentState.validate()) {
      /*old*/
      Navigator.of(context).pop();

      setState(() {});
      await _postPassword();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _postPassword() async {
    try {
      var url = Config.profile_password_update;
      print(url);

      var formData = {
        "password": _controllernewCPassword.text,
      };
      final response =
          await Services(url).postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Color(0xffc00e34),
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        ResetPassword _reset = new ResetPassword();
        _reset = ResetPassword.fromJson(response);
        if (_reset.status) {
          setState(() {
            sharedPreferences.setString(
                "password", _controllernewCPassword.text);
            line = ' * ' * _controllernewCPassword.text.length;
            password = _controllernewPassword.text;
          });
          Toast.show(
            _reset.message,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          // Navigator.of(context).pushReplacementNamed("/login");
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Color(0xffc00e34),
              content: Text(_reset.message),
              duration: Duration(seconds: 3)));
        }
      }
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Color(0xffc00e34),
        content: Text('Something went worng'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  showIndustry() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //  new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerIndustry,
                                      style: TextStyle(color: Colors.black),
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "INDUSTRY",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("industry",
                                                      _controllerIndustry.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Industry",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showCompany() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //  new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      controller: _controllerCompany,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "COMPANY NAME",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("company",
                                                      _controllerCompany.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Company name",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showAbout() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 12,
                                      controller: _controllerAbout,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.multiline,

//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "ABOUT",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("about",
                                                      _controllerAbout.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change About",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showDesignation() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      controller: _controllerDesignation,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "DESIGNATION",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile(
                                                      "designation",
                                                      _controllerDesignation
                                                          .text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Designation",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showPhone() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //new Text("Text 1"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      maxLength: 10,
                                      style: TextStyle(color: Colors.black),
                                      controller: _controllerPhone,
                                      keyboardType: TextInputType.number,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "PHONE",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  if(_controllerPhone.text.length==10) {
                                                    Navigator.of(context).pop();
                                                    _updateProfile("phone_no",
                                                        _controllerPhone.text);
                                                  }else{
                                                    Toast.show(
                                                      "Enter a valid Phone number",
                                                      context,
                                                      duration: Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM,
                                                    );
                                                  }
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Phone",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showFacebook() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      controller: _controllerFacebook,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(color: Colors.black),
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "FACEBOOK LINK",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("facebook",
                                                      _controllerFacebook.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change Facebook link",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  showLinkedIn() {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, right: 30.0, left: 30.0),
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 2,
                                      controller: _controllerLinkedIn,
                                      style: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.multiline,
//                                  decoration: InputDecoration.collapsed(
//                                    hintText: "Write a comment",
//
//                                  ),
                                      //initialValue: name,
                                      decoration: new InputDecoration(
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black)),
                                        labelText: "LINKEDIN LINK",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        focusedBorder: new UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  new Expanded(
                                      child: new Align(
                                          alignment: Alignment.bottomCenter,
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _updateProfile("facebook",
                                                      _controllerFacebook.text);
                                                  _updateProfile("linkedin",
                                                      _controllerLinkedIn.text);
                                                },
                                              )
                                            ],
                                          )))
                                ],
                              )),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(MdiIcons.close,
                                      size: 30.0, color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Change LinkedIn link",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//            Container(
//              // A simplified version of dialog.
//              width: 100.0,
//              height: 56.0,
//              color: Colors.green,
//              child: Text('jojo'),
//            )
              ),
            ));
  }

  _updateProfile(key, value) async {
    try {
      var formData = {
        key: value,
      };

      final response = await Services(Config.profile)
          .postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        setState(() {});
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          _profileModel = ProfileModel.fromJson(response);
          _userInformations = _profileModel.data.userInformations;
          sharedPreferences.setString(
              "userdetails", json.encode(_userInformations));
        });
        Toast.show(
          response['message'],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    } catch (e) {
      setState(() {});
      Toast.show(
        "Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  _removeImage() async {
    try {
      var formData = {"": ""};

      final response = await Services(Config.profile_image_remove)
          .postMethod(formData, context, _scaffoldKey);
      print(response);
      if (response == null) {
        setState(() {});
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('No data available'),
          duration: Duration(seconds: 3),
        ));
      } else {
        setState(() {
          var removeImage = RemoveImage.fromJson(response);
          if (removeImage.status) {
            profile = "";
            sharedPreferences.setString("profile_pic", "");
            Toast.show(
              removeImage.message,
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
            );
          } else {
            Toast.show(
              removeImage.message,
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
            );
          }
        });
        Toast.show(
          response['message'],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    } catch (e) {
      setState(() {});
      Toast.show(
        "Something went wrong please try again later",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }
}

class RemoveImage {
  String message;
  bool status;

  RemoveImage({this.message, this.status});

  RemoveImage.fromJson(Map<String, dynamic> json) {
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
