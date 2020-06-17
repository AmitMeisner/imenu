import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuList extends StatefulWidget {
  final List<String> typeList;
  final List<String> typeListHE;
  final String hebSuff;
  final ItemScrollController itemScrollController;

  const MenuList({Key key, this.typeList, this.itemScrollController, this.typeListHE, this.hebSuff}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuListState();
  }
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
//    return ListView.builder(itemBuilder: (context, i){
//      return Text(i.toString());
//    });
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child:
      ScrollablePositionedList.builder(
          physics: ScrollPhysics(),
          itemCount: widget.typeList.length,
          itemScrollController: widget.itemScrollController,
          itemBuilder: (context, i) {
            final String type = widget.typeList[i];
            final String typeHE = widget.typeListHE[i];
            return Column(
              children: [
                Text(widget.hebSuff == "" ? type : typeHE,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )),
                Divider(
                  thickness: 3,
                  color: Colors.black,
                ),
                TileGroupState(type: type, hebSuff: widget.hebSuff),
                SizedBox(height: 15)
              ],
            );
          }),

    );
  }
}

class TileGroupState extends StatelessWidget {
  final String type;
  final String hebSuff;

  const TileGroupState({Key key, this.type, this.hebSuff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(this.type.toLowerCase()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasData == null) {
            return Text('');
          }
          return ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children:
                List<Widget>.generate(snapshot.data.documents.length, (index) {
              return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    title: Text(snapshot.data.documents[index]["name"+this.hebSuff]),
                    subtitle: Text(snapshot.data.documents[index]["ingredients"+this.hebSuff]),
                    trailing: Text(snapshot.data.documents[index]["price"]),
                  ));
            }).toList(),
          );
        });
  }
}
