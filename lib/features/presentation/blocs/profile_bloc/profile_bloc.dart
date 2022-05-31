/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/service/api/get_profile.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{

  ProfileBloc(ProfileState initialState) : super(initialState) {
    on<ProfileInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<ProfileChangeEvent>((event, emit) => _changeProfile(event: event, emit: emit));
    on<ProfileChangePhotoEvent>((event, emit) => _uploadPhoto(event: event, emit: emit));

  }

  Future<void> _init({
    required ProfileInitEvent event,
    required Emitter<ProfileState> emit,
  }) async {
    try {
      ProfileModel profile = await getIt.get<GetProfile>().getProfile();

      emit(ProfileInitState(
        profile: profile,
      ));

    } catch (error) {
      print(error);
      emit(ProfileErrorState(error: error.toString()));
    }
  }

  Future<void> _changeProfile({
    required ProfileChangeEvent event,
    required Emitter<ProfileState> emit,
  }) async {

    emit(ProfileLoadingState());

    try {

      String result = await getIt.get<GetProfile>().changeProfile(
        name: event.name,
        surname: event.surname,
        username: event.username,
        phoneNumber: event.phone,
        email: event.email,
        job_title: event.job,
      );

      if(result == '') {
        emit(ProfileSuccessState());
      }else {
        emit(ProfileErrorState(error: result));
      }

    } catch(e) {
      print(e);
      emit(ProfileErrorState(error: "something_went_wrong"));
    }
  }

  Future<void> _uploadPhoto({
    required ProfileChangePhotoEvent event,
    required Emitter<ProfileState> emit,
  }) async {
    emit(ProfileLoadingState());

    try {

      bool result = await getIt.get<GetProfile>().changeAvatar(image: event.avatar);

      if(result) {
        emit(ProfileSuccessState());
      }else {
        emit(ProfileErrorState(error: 'unknown'));
      }

    } catch (error) {
      emit(ProfileErrorState(error: 'something_went_wrong'));
    }
  }
}