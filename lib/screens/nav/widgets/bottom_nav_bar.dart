import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;

  const BottomNavBar(
      {Key key,
      @required this.items,
      @required this.selectedItem,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = BottomNavItem.values.indexOf(selectedItem);
    return BottomNavigationBar(
        currentIndex: i,
        onTap: onTap,
        items: items
            .map(
              (item, icon) => MapEntry(
                item,
                BottomNavigationBarItem(
                  label: item.toString().split('.').last.toUpperCase(),
                  icon: item == this.selectedItem
                      ? Container(
                        height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(offset: Offset(1,2), blurRadius: 4, color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: FaIcon(icon, size: 20.0)),
                            ),
                          ),
                        )
                      : Center(child: FaIcon(icon, size: 20.0)),
                ),
              ),
            )
            .values
            .toList());
  }
}
