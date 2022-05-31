/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/attachment_model.dart';
import 'package:equatable/equatable.dart';

abstract class AttachmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttachmentShowState extends AttachmentState {
  final List<AttachmentModel> documents;

  AttachmentShowState({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class AttachmentLoadingState extends AttachmentState {}

class AttachmentErrorState extends AttachmentState {
  final String error;

  AttachmentErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}