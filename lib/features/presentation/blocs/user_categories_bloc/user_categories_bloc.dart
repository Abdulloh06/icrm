import 'package:icrm/core/models/user_categories_model.dart';
import 'package:icrm/core/service/api/get_user_categories.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_event.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCategoriesBloc extends Bloc<UserCategoriesEvent, UserCategoriesState>{

  UserCategoriesBloc(UserCategoriesState initialState) : super(initialState) {
    on<UserCategoriesInitEvent>((event, emit) async {
      try {
        final List<UserCategoriesModel> list = await getIt.get<GetUserCategories>().getUserCategories();

        emit(UserCategoriesInitState(list: list));

      } catch (error) {
        print(error);
        emit(UserCategoriesErrorState(error: error.toString()));
      }
    });

    on<UserCategoriesAddEvent>((event, emit) async {

      try {

        bool result = await getIt.get<GetUserCategories>().addUserCategory(name: event.name);

        if(result) {
          final List<UserCategoriesModel> list = await getIt.get<GetUserCategories>().getUserCategories();

          emit(UserCategoriesInitState(list: list));
        }else {
          emit(UserCategoriesErrorState(error: 'something_went_wrong'));
        }

      } catch (error) {
        print(error);
        emit(UserCategoriesErrorState(error: error.toString()));
      }

    });
  }

}