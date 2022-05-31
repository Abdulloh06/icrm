/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:equatable/equatable.dart';

abstract class AuthEvents extends Equatable {}

class AuthInitEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthSignInEvent extends AuthEvents {

  AuthSignInEvent({required this.username, required this.pinCode});

  final String username;
  final String pinCode;

  @override
  List<Object?> get props => [
    pinCode, username,
  ];
}

class AuthSignUpStepOne extends AuthEvents {
  final String email;
  final String phoneNumber;

  AuthSignUpStepOne({required this.email, required this.phoneNumber});

  @override
  List<Object?> get props => [email, phoneNumber];
}

class AuthSignUpStepTwo extends AuthEvents {
  final String via;
  final int code;

  AuthSignUpStepTwo({required this.via, required this.code});

  @override
  List<Object?> get props => [via, code];
}

class AuthSignUpConfirmation extends AuthEvents {

  final String via;
  final String password;

  AuthSignUpConfirmation({
    required this.via,
    required this.password,
  });

  @override
  List<Object?> get props => [via, password];

}

class AuthSignInWithPhoneEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthSignInWithEmailEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthGoogleSignInEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthFacebookSignInEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthYandexSignInEvent extends AuthEvents {
  final String token;

  AuthYandexSignInEvent({
    required this.token,
  });
  @override
  List<Object?> get props => [token];
}

class AuthGoogleSignUpEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}

class AuthFacebookSignUpEvent extends AuthEvents{
  @override
  List<Object?> get props => [];
}

class AuthYandexSignUpEvent extends AuthEvents {
  final String token;

  AuthYandexSignUpEvent({
    required this.token,
  });
  @override
  List<Object?> get props => [token];
}

class AppleSignUpEvent extends AuthEvents {
  @override
  List<Object?> get props => [];
}
