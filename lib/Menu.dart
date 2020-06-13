import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'Chips.dart';

class Menu extends StatefulWidget {
  scrollTrigger(index) => createState();

  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  ItemScrollController _scrollController = new ItemScrollController();

  @override
  Widget build(BuildContext context) {
    List<String> chipList = [
      "Hamburger",
      "French Fries",
      "Sushi",
      "Pineapple",
      "Fanta"
    ];
    List<ListItem> items = List<ListItem>.generate(
        (chipList.length-1) * 5,
        (i) => i % 5 == 0
            ? HeadingItem(chipList.elementAt(i~/5))
            : MessageItem("Man $i", "Rahiv $i"));
    return Column(children: <Widget>[
      SizedBox(
          height: 1000,
          child: ScrollablePositionedList.builder(
              physics: ScrollPhysics(),
              itemScrollController: _scrollController,
              itemCount: 19,
              itemBuilder: (context, index) =>
//              index%10 ==0 ? Text('Amit') : Text('Yes')
                  ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 19,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: item.buildTitle(context),
                      subtitle: item.buildSubtitle(context),
                    );
                  })
          ))
    ]);
  }

  void jumpTo(int index){
    _scrollController.jumpTo(index: index);
  }

}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}
