import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class updateFS extends StatelessWidget {
  final db = Firestore.instance;
  final colRef = Firestore.instance.collection("drinks");

  void createRecord(type, name, ingredients, price) async {
    await db
        .collection(type)
        .add({'name': name, 'ingredients': ingredients, 'price': price});
  }

  void updateData(type, docid, field, name, ingredients, price) {
    try {
      db
          .collection(type)
          .document(docid)
          .updateData({
        'name': name, 'ingredients': ingredients, 'price': price
          });
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData(type, docid) {
    try {
      db
          .collection(type)
          .document(docid)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void createBatchRecord() async {
    WriteBatch batch = db.batch();

    // ##important! - first see collection name in colRef

    batch.setData(colRef.document(), {
      'name': 'Cola Zero',
      'ingredients': '',
      'price': '₪12'
    });
    batch.setData(colRef.document(), {
      'name': 'Soda',
      'ingredients': '',
      'price': '₪10'
    });
    batch.setData(colRef.document(), {
      'name': 'Small Ferarelle',
      'ingredients': '',
      'price': '₪13'
    });
    batch.setData(colRef.document(), {
      'name': 'Small Ferarelle',
      'ingredients': '',
      'price': '₪13'
    });
    batch.setData(colRef.document(), {
      'name': 'Large Ferarelle',
      'ingredients': '',
      'price': '₪28'
    });
    batch.setData(colRef.document(), {
      'name': 'Large Natia',
      'ingredients': '',
      'price': '₪28'
    });


    batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Create Record'),
      onPressed: () {
        createBatchRecord();
      },
    );
  }
}
