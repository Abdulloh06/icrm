import 'package:avlo/core/service/api/get_profile.dart';
import 'package:avlo/core/util/get_it.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{

  ProfileBloc(ProfileState initialState) : super(initialState) {

    on<ProfileInitEvent>((event, emit) async {

      try {
        ProfileModel profile = await getIt.get<GetProfile>().getProfile();

        emit(ProfileInitState(
          profile: profile,
        ));

      } catch (error) {
        print(error);
        emit(ProfileErrorState(error: error.toString()));
      }

    });

    on<ProfileChangeEvent>((event, emit) async {

      emit(ProfileLoadingState());

      try {

        bool result = await getIt.get<GetProfile>().changeProfile(
          name: event.name,
          surname: event.surname,
          username: event.username,
          phoneNumber: event.phone,
          email: event.email,
          job_title: event.job,
        );

        if(result) {
          emit(ProfileSuccessState());
        }else {
          emit(ProfileErrorState(error: 'something_went_wrong'));
        }

      } catch(e) {
        print(e);
        emit(ProfileErrorState(error: e.toString()));
      }

    });

    on<ProfileChangePhotoEvent>((event, emit) async {
      emit(ProfileLoadingState());

      try {

        bool result = await getIt.get<GetProfile>().changeAvatar(image: event.avatar);

        if(result) {
          emit(ProfileSuccessState());
        }else {
          emit(ProfileErrorState(error: 'unknown'));
        }

      } catch (error) {

      }

    });

  }

}