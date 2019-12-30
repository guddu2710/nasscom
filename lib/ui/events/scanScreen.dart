import 'package:barcode_scan/barcode_scan.dart';
import 'package:event_management/service/config.dart';
import 'package:event_management/service/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String qrText = "";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //QRViewController controller;

  @override
  initState() {
    //_onQRViewCreated(this.controller);ssdash
    _scanQR();
    super.initState();
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        print("reo" + qrResult);
        // result = ;
        _getEvent(qrResult);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          Navigator.of(context).pop();

          Toast.show(
            "Camera permission was denied",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        });
      } else {
        setState(() {
          Navigator.of(context).pop();

          Toast.show(
            "Unknown Error $ex",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        });
      }
    } on FormatException {
      setState(() {
        Navigator.of(context).pop();

        Toast.show(
          "You pressed the back button before scanning anything",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      });
    } catch (ex) {
      setState(() {
        Navigator.of(context).pop();
        Toast.show(
          "Unknown Error $ex",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      });
    }
  }

//  void _onQRViewCreated(QRViewController controller) {
//    final channel = controller.channel;
//    var init = controller.init(qrKey);
//    this.controller = controller;
//    channel.setMethodCallHandler((MethodCall call) async {
//      switch (call.method) {
//        case "onRecognizeQR":
//          dynamic arguments = call.arguments;
//          setState(() {
//            qrText = arguments.toString();
//          });
//          _getEvent(qrText);
//      }
//    });
//  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
          backgroundColor: Colors.black54,
          body: new Center(
            child: new Container(),
          )),
    );
  }

  _getEvent(barcode) async {
    try {
      var url = Config.qr_code;
      print("url"+url);
      var formData = {
        "event_id": barcode,
      };
      final response = await Services(url).postMethod(formData, context);
     // print("respon"+response);
      if (response == null) {
        Navigator.of(context).pop();
        Toast.show(
          "No data available",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      } else {
        var s = Scan.fromJson(response);
        if (s.status) {
          Navigator.of(context).pop();
          Toast.show(
            s.message,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        } else {
          Navigator.of(context).pop();
          Toast.show(
            s.message,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        }
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pop();


//      setState(() {
//      //  _isloading = false;
//      });
//      Toast.show("product Something went wrong please try again later", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
    }
  }
}

class Scan {
  String message;
  bool status;

  Scan({this.message, this.status});

  Scan.fromJson(Map<String, dynamic> json) {
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
