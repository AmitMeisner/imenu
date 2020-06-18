import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imenu/MenuList.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'Chips.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quattro iMenu',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Quattro iMenu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> typeList = [];
  List<String> typeListHE = [];
  bool loaded = false;
  ItemScrollController itemScrollerController = ItemScrollController();
  bool isSwitched = true;
  String hebSuff = "HE";
  List<String> message = [""];
  List<String> messageHE = [""];

  void updateMessage() async { // calling to upstaetypeList who calling setState()
    List<String> newMessage = [];
    List<String> newMessageHE = [];
    CollectionReference colRef = Firestore.instance.collection('user');
    await colRef.document('1').get().then((doc) {
      newMessage = List.from(doc.data["message"]);
      newMessageHE = List.from(doc.data["message"+hebSuff]);
      updatetypeList(newMessage, newMessageHE);
    });
  }

  void updatetypeList(List<String> newMessage, List<String> newMessageHE) async {
    List<String> newTypeList = [];
    List<String> newTypeListHE = [];
    CollectionReference colRef = Firestore.instance.collection('dishtype');
    await colRef.where("place", isGreaterThan: -1).orderBy('place').getDocuments().then((docSnap) {
      docSnap.documents.forEach((name) {
        newTypeListHE.add(name.data["nameHE"]);
        newTypeList.add(name.data["name"]);
      });
    }).then((val) {
      Future.delayed(const Duration(milliseconds: 2000), ()
      {
        setState(() {
          message = newMessage;
          messageHE = newMessageHE;
          typeList = newTypeList;
          typeListHE = newTypeListHE;
          loaded = true;
        });
      }
      );
    });
  }

  @override
  void initState() {
    updateMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title,
          style: TextStyle(
              color: Colors.white
          )),
          backgroundColor: Colors.black87,
          actions: <Widget>[
            Switch(
              value: isSwitched,
              onChanged: (value){
                setState(() {
                  isSwitched=value;
                  hebSuff == "" ? hebSuff = "HE" : hebSuff = "";
                });
              },
              activeTrackColor: Colors.white10,
              activeColor: Colors.white30,
              inactiveTrackColor: Colors.white10,
//              activeColor: Colors.grey,
              activeThumbImage: AssetImage('assets/heIcon.png'),
              inactiveThumbImage: AssetImage('assets/enIcon.png'),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (loaded == true)
                  Column(
                    children: [
                      Chips(
                        typeListRender: hebSuff == "HE" ? this.typeListHE : this.typeList,
                        itemScrollController: itemScrollerController
                      ),
                      MenuList(
                          typeList: this.typeList,
                          typeListHE: this.typeListHE,
                          hebSuff: hebSuff,
                          itemScrollController: itemScrollerController,
                        message: message,
                        messageHE: messageHE,
                      ),
                    ],
                  )
                else Center(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 180,
                              width: 180,
                              child: Image.asset(
                                  'assets/quattroLogo.jpg',
                              fit: BoxFit.contain,
                              )
                          )
                      ),
                      Loading(
                        indicator: BallPulseIndicator(),
                      size: 150,
                      color: Colors.black
                      ),
                    ],
                  ),
                )
              ],
            )
        ),

      );
  }
}
