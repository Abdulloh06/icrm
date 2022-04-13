import 'package:icrm/core/service/api/auth/get_yandex_email.dart';
import 'package:icrm/core/service/api/auth/login_service.dart';
import 'package:icrm/core/service/api/auth/sign_up_service.dart';
import 'package:icrm/core/service/api/auth/social_auth.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        String result = await getIt.get<LoginService>().login(
          username: event.username,
          password: event.pinCode,
        );

        if (result == '') {
          emit(AuthSignInSuccessSate());
        } else if (result.contains('user')) {
          emit(AuthErrorState(error: 'user_not_found'));
        }
      } catch (error) {
        print(error);
        if(error.toString().contains('user')) {
          emit(AuthErrorState(error: 'user_not_found'));
        }else {
          emit(AuthErrorState(error: "something_went_wrong"));
        }
      }
    });

    on<AuthSignUpStepOne>((event, emit) async {
      emit(AuthLoadingState());

      try {
        String result = await getIt
            .get<SignUpService>()
            .signUpStepOne(email: event.email, phone: event.phoneNumber);

        print(result);

        if (result == '') {
          emit(AuthSignUpSuccessOne(
              via: event.email == ''
                  ? event.phoneNumber.toString()
                  : event.email));
        } else if (result == 'user' || result == 'user_already_exist') {
          emit(AuthErrorState(error: 'user_already_exists'));
        } else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        emit(AuthErrorState(error: error.toString()));
      }
    });

    on<AuthSignUpStepTwo>((event, emit) async {
      emit(AuthLoadingState());

      try {
        bool result = await getIt
            .get<SignUpService>()
            .registerStepTwo(via: event.via, code: event.code);

        if (result) {
          emit(AuthSignUpSuccessTwo(via: event.via));
        } else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      } catch (e) {
        print(e);
        emit(AuthErrorState(error: e.toString()));
      }
    });

    on<AuthSignUpConfirmation>((event, emit) async {
      emit(AuthLoadingState());

      try {
        bool result = await getIt.get<SignUpService>().registerConfirmation(
              via: event.via,
              password: event.password,
              confirmPassword: event.confirmPassword,
            );

        if (result) {
          emit(AuthSignUpSuccessConfirm());
        } else {
          emit(AuthErrorState(error: result.toString()));
        }
      } catch (e) {
        print('Sign up step-confirmation + $e');
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    });

    on<AuthGoogleSignInEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        Map<String, dynamic> result = await _getGoogleEmail();

        if (result['result']) {
          String signIn = await getIt.get<LoginService>().login(
                username: result['email'],
                password: result['password'],
              );

          if (signIn == '') {
            emit(AuthSignInSuccessSate());
          } else if (signIn.contains('user')) {
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
    });

    on<AuthYandexSignInEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        final mail = await getIt.get<YandexAuth>().getYandexMail();

        print(mail);

        emit(AuthYandexAuthState());
      } catch (e) {
        emit(AuthErrorState(error: 'something_went_wrong'));
      }
    });

    on<AuthFacebookSignInEvent>((event, emit) async {
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
            emit(AuthErrorState(error: facebookAuth.message.toString()));
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
        if(e.toString().contains('user')) {
          emit(AuthErrorState(error: 'user_not_found'));
        }else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      }
    });

    on<AuthGoogleSignUpEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        Map<String, dynamic> result = await _getGoogleEmail();

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
          } else {
            emit(AuthErrorState(error: 'user_already_exists'));
          }
        } else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        if(error.toString().contains('email')) {
          emit(AuthErrorState(error: 'user_already_exists'));
        }else {
          emit(AuthErrorState(error: 'something_went_wrong'));
        }
      }
    });

    on<AuthFacebookSignUpEvent>((event, emit) async {
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
            } else if (signIn == 'user') {
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
    });
  }

  Future<Map<String, dynamic>> _getGoogleEmail() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        return {'result': false};
      }

      final GoogleSignInAuthentication googleAuth = await user.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user?.email != null) {
        String name = '', surname = '';

        if (authResult.user?.displayName != null) {
          List<String> list = authResult.user!.displayName!.split(' ');
          name = list[0];
          surname = list[1];
        }

        return {
          'result': true,
          'email': authResult.user?.email,
          'password': authResult.user?.uid,
          'phone': authResult.user?.phoneNumber,
          'name': name,
          'surname': surname,
          'user_photo': authResult.user?.photoURL,
        };
      } else {
        print('Error: result = false');
        return {'result': false};
      }
    } catch (e) {
      print('Error while getting email - $e');
      return {'result': false};
    }
  }
}
