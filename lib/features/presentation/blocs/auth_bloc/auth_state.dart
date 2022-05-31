/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';

abstract class AuthStates extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthInitState extends AuthStates {
  @override
  List<Object?> get props => [];
}

class AuthSignInWithPhoneState extends AuthStates {}

class AuthSignInWithEmailState extends AuthStates {}

class AuthSignInSuccessSate extends AuthStates {}

class AuthSignUpSuccessOne extends AuthStates {
  final String via;

  AuthSignUpSuccessOne({required this.via});

  @override
  List<Object?> get props => [via];
}

class AuthSignUpSuccessTwo extends AuthStates {
  final String via;

  AuthSignUpSuccessTwo({required this.via});

  @override
  List<Object?> get props => [via];
}

class AuthSignUpSuccessConfirm extends AuthStates {}

class AuthSignUpFromSocialSuccess extends AuthStates {
  final String email;
  final String password;

  AuthSignUpFromSocialSuccess({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLoadingState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState({required this.error});
}