import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_ui/authentication/bloc.dart';
import 'package:flutter_ui/user_repository.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _userRepository.getUser();
        var name = currentUser.displayName != null
            ? currentUser.displayName
            : currentUser.email;
        yield Authenticated(displayName: name, photoUrl: currentUser.photoUrl);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final currentUser = await _userRepository.getUser();
    var name = currentUser.displayName != null
        ? currentUser.displayName
        : currentUser.email;
    yield Authenticated(
      displayName: name,
      photoUrl: currentUser.photoUrl,
    );
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
