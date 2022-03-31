import 'package:equatable/equatable.dart';

abstract class AuthEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

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
  final String confirmPassword;

  AuthSignUpConfirmation({required this.via, required this.password, required this.confirmPassword});

  @override
  List<Object?> get props => [via, password, confirmPassword];

}

class AuthSignInWithPhoneEvent extends AuthEvents {}

class AuthSignInWithEmailEvent extends AuthEvents {}

class AuthGoogleSignInEvent extends AuthEvents {}

class AuthFacebookSignInEvent extends AuthEvents {}

class AuthYandexSignInEvent extends AuthEvents {}

class AuthGoogleSignUpEvent extends AuthEvents {}

class AuthFacebookSignUpEvent extends AuthEvents{}

class AuthYandexSignUpEvent extends AuthEvents {}

