
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarCubit extends Cubit<int> {
  BottomBarCubit() : super(0);

  int page = 0;

  void changePage(int newPage) {
    if(newPage != page) emit(page = newPage);
  }
}
