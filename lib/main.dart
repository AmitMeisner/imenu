import 'package:cloud_firestore/cloud_firestore.dart';
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iMenu Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
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
  bool loaded = false;
  ItemScrollController itemScrollerController = ItemScrollController();

  void updatetypeList() async {
    List<String> newTypeList = [];
    CollectionReference colRef = Firestore.instance.collection('dishtype');
    await colRef.where("place", isGreaterThan: -1).orderBy('place').getDocuments().then((docSnap) {
      docSnap.documents.forEach((name) {
        newTypeList.add(name.data["name"]);
      });
    }).then((val) {
      Future.delayed(const Duration(milliseconds: 2000), ()
      {
        setState(() {
          typeList = newTypeList;
          loaded = true;
        });
      }
      );
    });
  }

  @override
  void initState() {
    updatetypeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (loaded == true)
                  Column(
                    children: [
                      Chips(typeList: this.typeList, itemScrollController: itemScrollerController,),
                      MenuList(typeList: this.typeList, itemScrollController: itemScrollerController),
                    ],
                  )
                else Center(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/quattroLogo.jpg')
                      ),
                      Loading(
                        indicator: BallPulseIndicator(),
                      size: 100,
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
