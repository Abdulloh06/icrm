import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitEvent extends ProfileEvent {}

class ProfileChangeEvent extends ProfileEvent {
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final String job;

  ProfileChangeEvent({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.username,
    required this.job,
  });

  @override
  List<Object?> get props => [name, surname, email, username, phone, job];
}

class ProfileChangePhotoEvent extends ProfileEvent {
  final File avatar;

  ProfileChangePhotoEvent({required this.avatar});

}