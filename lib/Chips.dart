import 'dart:async';

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
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: List<Widget>.generate(
            5,
            (int index) {
              return ChoiceChip(
                padding: EdgeInsets.symmetric(horizontal: 8),
                label: Text(chipList.elementAt(index)),
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
//                    MenuState().jumpTo(index: index*5);
                    _value = index;
                  });
                },
              );
            },
          ).toList(),
//          Chip(
//            label: Text('Aaron Burr'),
//          )
        ));
  }
}
