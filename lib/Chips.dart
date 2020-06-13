import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imenu/Menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Chips extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    List<String> chipList = [
      "Hamburger",
      "French Fries",
      "Sushi",
      "Pineapple",
      "Fanta"
    ];
    return Container(
        height: 70.0,
        child: StreamBuilder(
          stream: Firestore.instance.collection('dishtype').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData|| snapshot.hasData== null) return const Text('Loading...');
            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: List<Widget>.generate(
                6,
                (int index) {
                  return ChoiceChip(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    label: Text(snapshot.data.documents[index]['name']),
                    selected: _value == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _value = index;
                      });
                    },
                  );
                },
              ).toList(),
//          Chip(
//            label: Text('Aaron Burr'),
//          )
            );
          }
        ));
  }
}
