import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';



class Chips extends StatefulWidget {
  final List<String> typeList;
  final ItemScrollController itemScrollController;

  const Chips({Key key, this.typeList, this.itemScrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: 70.0,
          child:
              ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List<Widget>.generate(
              widget.typeList.length,
              (int index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ChoiceChip(
                    label: Text(
                        widget.typeList[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    selected: _value == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _value = index;
                        widget.itemScrollController.scrollTo(index: index, duration: Duration(seconds: 1));
                      });
                    },
                  ),
                );
              },
            ).toList(),
          )),
    );
  }
}
