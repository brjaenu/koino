import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jugruppe/auth/authentication_service.dart';
import 'package:jugruppe/auth/authentication_wrapper.dart';
import 'package:jugruppe/auth/signup_page.dart';
import 'package:jugruppe/util/circularloading_widget.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  analytics = FirebaseAnalytics();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong...'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return JuGruppeApp();
          }

          return CircularLoadingWidget();
        });
  }
}

class JuGruppeApp extends StatelessWidget {
  const JuGruppeApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: FirebaseAuth.instance.currentUser,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: AuthenticationWrapper(),
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
        routes: {
          AuthenticationWrapper.routeName: (ctx) => AuthenticationWrapper(),
          SignUpPage.routeName: (ctx) => SignUpPage()
        },
      ),
    );
  }
}
