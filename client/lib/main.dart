import 'package:flutter/material.dart';
import 'package:flutter_feasibility/store/eventor.dart';
import 'package:flutter_feasibility/store/global.dart';
import 'package:flutter_feasibility/store/store.dart';
import 'package:flutter_feasibility/ui/screens/room.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'ui/screens/home.dart';
import 'ui/screens/login.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final Store _store = Store(Eventor());

  App({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<Global>.value(
      value: _store.global,
      child: MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'doozoo WebRTC Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ));

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => HomeScreen(
          store: _store,
        ),
      ),
      GoRoute(
        path: '/room',
        builder: (BuildContext context, GoRouterState state) => RoomScreen(
          store: _store,
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginScreen(
          eventor: _store.eventor,
        ),
      ),
    ],

    // redirect to the login page if the user is not logged in
    redirect: (GoRouterState state) {
      // if the user is not logged in, they need to login
      final bool loggedIn = _store.global.loggedIn;
      final bool loggingIn = state.subloc == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      // is the user inside a room?
      if (_store.global.insideRoom) {
        if (state.subloc != '/room') {
          return '/room';
        }
      } else {
        if (state.subloc == '/room') {
          return '/';
        }
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        print("Still logged in");
        return '/';
      }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: _store.global,
  );
}
