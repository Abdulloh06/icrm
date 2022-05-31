/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipeAnimationCubit extends Cubit<bool> {
  SwipeAnimationCubit(bool initialState) : super(UserToken.animate);

  void disableAnimation() {

    emit(UserToken.animate = false);

  }

}