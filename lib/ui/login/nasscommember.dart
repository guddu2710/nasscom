import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'company_dialoge.dart';
class NasscomMember extends StatefulWidget {
  @override
  _NasscomMemberState createState() => _NasscomMemberState();
}

class _NasscomMemberState extends State<NasscomMember> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(100, (i) => "Item $i");
  var items = List<String>();
  String selectedCompany="";

  @override
  void initState() {
    // TODO: implement initState
    editingController.addListener(textListener);

    items.addAll(duplicateItems);

    super.initState();
  }
  void textListener() {
    List<String> dummySearchList = List<String>();

   // dummySearchList.addAll(duplicateItems);
    if(editingController.text.isNotEmpty) {
      List<String> dummyListData = List<String>();
      duplicateItems.forEach((item) {
        if(item.toLowerCase().contains(editingController.text)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "image/Spash_screen_back.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Are u already a nasscom member?"),
                  SizedBox(height: 30.0,),
                  RadioButtonGroup(
                      labels: <String>[
                        "Yes",
                        "No",
                      ],
                      onSelected: (String selected) {print(selected);
                      if(selected.toLowerCase()=="yes"){
                        _showOverlay(context);
                      }
                      setState(() {
                        selectedCompany=selected;
                      });}
                  ),
                  Text(selectedCompany),
                  Row(
                  children: <Widget>[
                    Text("Skip",style: TextStyle(decoration: TextDecoration.underline),)
                  ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  void _showOverlay(BuildContext context) {


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
                      color: Colors.white,
                child: Column(
                children: <Widget>[
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    print(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
                    );
                  },
                ),
              ),
              ],
            ),
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
                                "Select Company",
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
}
