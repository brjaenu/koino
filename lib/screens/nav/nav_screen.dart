import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/auth/auth_bloc.dart';
import 'package:koino/enums/enums.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/screens/profile/bloc/profile_bloc.dart';
import 'package:koino/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavBarCubit>(
            create: (_) => BottomNavBarCubit(),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
            )..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user.uid)),
          ),
        ],
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
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.failure) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              return Scaffold(
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
                bottomNavigationBar: BottomNavBar(
                  items: items,
                  selectedItem: state.selectedItem,
                  onTap: (i) {
                    final selectedItem = BottomNavItem.values[i];
                    _selectBottomNavItem(context, selectedItem,
                        selectedItem == state.selectedItem);
                  },
                ),
              );
            },
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
