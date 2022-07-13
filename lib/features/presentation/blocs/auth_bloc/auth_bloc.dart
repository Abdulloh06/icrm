/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/service/api/auth/social/get_google_email.dart';
import 'package:icrm/core/service/api/auth/social/get_yandex_email.dart';
import 'package:icrm/core/service/api/auth/login_service.dart';
import 'package:icrm/core/service/api/auth/sign_up_service.dart';
import 'package:icrm/core/service/api/auth/social/social_auth.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc(AuthStates initialState) : super(initialState) {
    on<AuthInitEvent>((event, emit) {
      emit(AuthInitState());
      emit(AuthSignInWithPhoneState());
    });
    on<AuthSignInWithPhoneEvent>(
        (event, emit) => emit(AuthSignInWithPhoneState()));
    on<AuthSignInWithEmailEvent>(
        (event, emit) => emit(AuthSignInWithEmailState()));

    on<AuthSignInEvent>((event, emit) => _login(event: event, emit: emit));
    on<AuthSignUpStepOne>((event, emit) => _signUpStepOne(event: event, emit: emit));
    on<AuthSignUpStepTwo>((event, emit) => _signUpStepTwo(event: event, emit: emit));
    on<AuthSignUpConfirmation>((event, emit) => _signUpConfirmation(event: event, emit: emit));
    on<AuthGoogleSignInEvent>((event, emit) => _googleSignIn(event: event, emit: emit));
    on<AuthYandexSignInEvent>((event, emit) => _yandexSignIn(event: event, emit: emit));
    on<AuthFacebookSignInEvent>((event, emit) => _facebookSignIn(event: event, emit: emit));
    on<AuthGoogleSignUpEvent>((event, emit) => _googleSignUp(event: event, emit: emit));
    on<AuthFacebookSignUpEvent>((event, emit) => _facebookSignUp(event: event, emit: emit));
    on<AuthYandexSignUpEvent>((event, emit) => _yandexSignUp(event: event, emit: emit));
  }

  Future<void> _login({
    required AuthSignInEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      String result = await getIt.get<LoginService>().login(
        username: event.username,
        password: event.pinCode,
      );

      if (result == '') {
        emit(AuthSignInSuccessSate());
      } else if (result == 'user_not_found') {
        emit(AuthErrorState(error: 'user_not_found'));
      }else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _signUpStepOne({
    required AuthSignUpStepOne event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      String result = await getIt.get<SignUpService>()
          .signUpStepOne(email: event.email, phone: event.phoneNumber);

      if (result == '') {
        emit(AuthSignUpSuccessOne(
            via: event.email == ''
                ? event.phoneNumber.toString()
                : event.email));
      } else if (result == 'user_already_exists') {
        emit(AuthErrorState(error: 'user_already_exists'));
      } else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _signUpStepTwo({
    required AuthSignUpStepTwo event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      String result = await getIt
          .get<SignUpService>()
          .registerStepTwo(via: event.via, code: event.code);

      if (result == "") {
        emit(AuthSignUpSuccessTwo(via: event.via));
      } else {
        emit(AuthErrorState(error: result));
      }
    } catch (e) {
      print(e);
      emit(AuthErrorState(error: "something_went_wrong"));
    }
  }

  Future<void> _signUpConfirmation({
    required AuthSignUpConfirmation event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      bool result = await getIt.get<SignUpService>().registerConfirmation(
        via: event.via,
        password: event.password,
      );

      if (result) {
        emit(AuthSignUpSuccessConfirm());
      } else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    } catch (e) {
      print('Sign up step-confirmation + $e');
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _googleSignIn({
    required AuthGoogleSignInEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      Map<String, dynamic> result = await getIt.get<GetGoogleEmail>().getGoogleEmail();

      if (result['result']) {
        String signIn = await getIt.get<LoginService>().login(
          username: result['email'],
          password: result['password'],
        );

        if (signIn == '') {
          emit(AuthSignInSuccessSate());
        } else if (signIn == 'user_not_found') {
          emit(AuthErrorState(error: 'user_not_found'));
        } else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      } else {
        emit(AuthInitState());
      }
    } catch (error) {
      print(error);
      if(error.toString().contains('user')) {
        emit(AuthErrorState(error: 'user_not_found'));
      }else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    }
  }

  Future<void> _yandexSignIn({
    required AuthYandexSignInEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      final mail = await getIt.get<YandexAuth>().getYandexMail(
        token: event.token,
      );

      String result = await getIt.get<LoginService>().login(
        username: mail['default_email'],
        password: mail['client_id'],
      );

      if(result == '') {
        emit(AuthSignUpFromSocialSuccess(
          email: mail['default_email'],
          password: mail['client_id'],
        ));
      } else if (result == 'user_not_found') {
        emit(AuthErrorState(error: 'user_not_found'));
      } else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }

    } catch (e) {
      print(e);
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _facebookSignIn({
    required AuthFacebookSignInEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      final facebookAuth = await FacebookAuth.instance.login();
      final userInfo = await FacebookAuth.i.getUserData();

      switch (facebookAuth.status) {
        case LoginStatus.success:
          print(facebookAuth.accessToken!.token);
          String signIn = await getIt.get<LoginService>().login(
            username: userInfo['email'],
            password: userInfo['id'],
          );

          if (signIn == '') {
            emit(AuthSignInSuccessSate());
          } else {
            emit(AuthErrorState(error: "user_not_found"));
          }

          break;
        case LoginStatus.cancelled:
          emit(AuthInitState());
          break;
        case LoginStatus.failed:
          emit(AuthErrorState(error: facebookAuth.message.toString()));
          break;
        case LoginStatus.operationInProgress:
          emit(AuthLoadingState());
          break;
      }
    } catch (e) {
      print(e);
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _googleSignUp({
    required AuthGoogleSignUpEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      Map<String, dynamic> result = await getIt.get<GetGoogleEmail>().getGoogleEmail();

      if (result['result']) {
        String signUp = await getIt.get<SocialAuth>().socialAuth(
          name: result['name'],
          password: result['password'],
          auth_type: 'google',
          phone_number: result['phone'] ?? '',
          email: result['email'],
        );

        if (signUp == '') {
          emit(AuthSignUpFromSocialSuccess(
              email: result['email'], password: result['password']));
        } else if(signUp == 'email'){
          emit(AuthErrorState(error: 'user_already_exists'));
        }
      } else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }

  Future<void> _facebookSignUp({
    required AuthFacebookSignUpEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      final facebookAuth = await FacebookAuth.instance.login();
      final userInfo = await FacebookAuth.i.getUserData();

      String name = userInfo['name'].toString().split(' ').first;
      String surname = userInfo['name'].toString().split(' ').last;
      switch (facebookAuth.status) {
        case LoginStatus.success:
          String signIn = await getIt.get<SocialAuth>().socialAuth(
            name: name,
            surname: surname,
            password: userInfo['id'],
            auth_type: 'facebook',
            phone_number: '',
            email: userInfo['email'],
          );
          if (signIn == '') {
            emit(AuthSignUpFromSocialSuccess(
              email: userInfo['email'],
              password: userInfo['id'],
            ));
          } else if (signIn == 'email') {
            emit(AuthErrorState(error: "user_already_exists"));
          } else {
            emit(AuthErrorState(error: "something_went_wrong"));
          }

          break;
        case LoginStatus.cancelled:
          emit(AuthInitState());
          break;
        case LoginStatus.failed:
          emit(AuthErrorState(error: facebookAuth.message.toString()));
          break;
        case LoginStatus.operationInProgress:
          emit(AuthLoadingState());
          break;
      }
    } catch (e) {
      print(e);
      emit(AuthErrorState(error: 'something_went_wrong'));
    }
  }
  
  Future<void> _yandexSignUp({
    required AuthYandexSignUpEvent event,
    required Emitter<AuthStates> emit,
  }) async {
    emit(AuthLoadingState());

    try {
      final mail = await getIt.get<YandexAuth>().getYandexMail(
        token: event.token,
      );

      String result = await getIt.get<SocialAuth>().socialAuth(
        name: mail['first_name'],
        password: mail['client_id'],
        auth_type: 'yandex',
        phone_number: '',
        email: mail['default_email'],
        surname: mail['last_name'],
      );

      if(result == '') {
        emit(AuthSignUpFromSocialSuccess(
          email: mail['default_email'],
          password: mail['client_id'],
        ));
      } else if (result == 'email') {
        emit(AuthErrorState(error: 'user_already_exist'));
      } else {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }

    } catch (e) {
      print(e);
      emit(AuthErrorState(error: e.toString()));
    }
  }
  
}
