/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPageSliderCubit extends Cubit<int> {
  AuthPageSliderCubit() : super(0);

  int page = 0;

  void changePage(int newPage) {
    if(newPage != page) emit(page = newPage);
  }
}
