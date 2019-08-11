import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui/authentication/authentication_bloc.dart';
import 'package:flutter_ui/authentication/authentication_state.dart';
import 'package:flutter_ui/home_screen.dart';
import 'package:flutter_ui/login/login_screen.dart';
import 'package:flutter_ui/splash_screen.dart';
import 'package:flutter_ui/util/app_theme.dart';

import 'authentication/authentication_event.dart';
import 'user_repository.dart';
import 'util/bloc_delegate.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runZoned<Future<void>>(() async {
    runApp(
      BlocProvider(
        builder: (context) =>
        AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted()),
        child: FriendlyChatApp(userRepository: userRepository),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}

class FriendlyChatApp extends StatelessWidget {
  final UserRepository _userRepository;

  FriendlyChatApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FlutterChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
            return HomeScreen(
              name: state.displayName,
              photoUrl: state.photoUrl,
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
