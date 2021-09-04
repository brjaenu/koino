import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/config/custom_router.dart';
import 'package:koino/enums/bottom_nav_item.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.agenda:
        return BlocProvider(
          create: (context) => EventBloc(
            eventRepository: context.read<EventRepository>(),
            userBloc: context.read<UserBloc>(),
          )..add(EventCreateEventStream()),
          child: AgendaScreen(),
        );
      case BottomNavItem.prayerwall:
        return PrayerwallScreen();
      case BottomNavItem.group:
        return ManageGroupScreen();
      default:
        return Scaffold();
    }
  }
}
