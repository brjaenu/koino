import 'package:flutter/material.dart';
import 'package:koino/screens/create_event/create_event_screen.dart';
import 'package:koino/screens/groups/groups_screen.dart';
import 'package:koino/screens/login/login_screen.dart';
import 'package:koino/screens/nav/nav_screen.dart';
import 'package:koino/screens/screens.dart';
import 'package:koino/screens/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case GroupsScreen.routeName:
        return GroupsScreen.route();
      case CreateGroupScreen.routeName:
        return CreateGroupScreen.route();
      case CreateEventScreen.routeName:
        return CreateEventScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
