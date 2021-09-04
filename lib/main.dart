import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/simple_bloc_observer.dart';
import 'package:koino/config/custom_router.dart';
import 'package:koino/repositories/group/group_repository.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:koino/util/CustomTheme.dart';

import 'blocs/auth/auth_bloc.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // GoogleAnalytics
  analytics = FirebaseAnalytics();

  // Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // if (kDebugMode) {
  EquatableConfig.stringify = kDebugMode;
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KoinoApp();
  }
}

class KoinoApp extends StatelessWidget {
  const KoinoApp({
    final Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => GroupRepository()),
        RepositoryProvider(create: (_) => EventRepository()),
        RepositoryProvider(create: (_) => RegistrationRepository()),
        RepositoryProvider(create: (_) => PrayerRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Koino',
          theme: CustomTheme.lightTheme,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [const Locale('de')],
        ),
      ),
    );
  }
}
