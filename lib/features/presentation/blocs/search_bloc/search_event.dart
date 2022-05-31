/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class SearchInitEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}

class SearchProjectEvent extends SearchEvent {
  @override
  List<Object?> get props => [];
}