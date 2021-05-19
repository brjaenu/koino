import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/enums/enums.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.agenda: GlobalKey<NavigatorState>(),
    BottomNavItem.prayerwall: GlobalKey<NavigatorState>(),
    BottomNavItem.group: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>()
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.agenda: Icons.home,
    BottomNavItem.prayerwall: Icons.book,
    BottomNavItem.group: Icons.group,
    BottomNavItem.profile: Icons.person
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (i) {
                final selectedItem = BottomNavItem.values[i];
                _selectBottomNavItem(
                    context, selectedItem, selectedItem == state.selectedItem);
              },
            ),
            body: Stack(
              children: items
                  .map((item, _) => MapEntry(
                        item,
                        _buildOffstageNavigator(
                            item, item == state.selectedItem),
                      ))
                  .values
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        item: currentItem,
      ),
    );
  }
}
