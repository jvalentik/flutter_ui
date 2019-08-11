import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final String displayName;
  final String photoUrl;

  Authenticated({this.displayName, this.photoUrl})
      : super([displayName, photoUrl]);

  @override
  String toString() =>
      'Authenticated { displayName: $displayName, photUrl: $photoUrl'
      ' }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
