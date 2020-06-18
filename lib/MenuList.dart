import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuList extends StatefulWidget {
  final List<String> typeList;
  final List<String> typeListHE;
  final String hebSuff;
  final ItemScrollController itemScrollController;
  final List<String> message;
  final List<String> messageHE;

  const MenuList({Key key, this.typeList, this.itemScrollController, this.typeListHE, this.hebSuff, this.message, this.messageHE}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuListState();
  }
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
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
            return
              Column(
              children: [
                if (i == 0 && widget.message != null && widget.message != [])
                  ListView(
                    shrinkWrap: true,
                    children: List<Widget>.generate( widget.message.length, (index){
                      return widget.hebSuff == "" ? Text(widget.message[index]) : Align(
                          alignment: Alignment.bottomRight,
                          child: Text(widget.messageHE[index]));
                    }
                    ).toList(),
                  ),
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

  Future getImageUrl() async{
    var ref = FirebaseStorage.instance.ref().child("Caprese");
    return await ref.getDownloadURL();
  }

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
                  String imageUrl = snapshot.data.documents[index]["imageUrl"];
              return Padding(
                  padding: const EdgeInsets.all(2),
                  child:
                  ExpansionTile(
                    title: Text(snapshot.data.documents[index]["name"+this.hebSuff],
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20)),
                    subtitle: Text(snapshot.data.documents[index]["ingredients"+this.hebSuff]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            child: imageUrl == "" ? null : Image.network(imageUrl),
                        ),
                        Text(snapshot.data.documents[index]["price"]),
                      ],
                    ),
                    children: <Widget>[
                    if (imageUrl != "")
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imageUrl,
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  )
              );
            }).toList(),
          );
        });
  }
}
