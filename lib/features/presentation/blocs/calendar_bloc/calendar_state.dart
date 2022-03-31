import 'package:equatable/equatable.dart';
import '../../../../core/models/calendar_model.dart';

abstract class CalendarState extends Equatable {}

class CalendarInitState extends CalendarState {

  final CalendarModel calendar;

  CalendarInitState({
    required this.calendar,
  });

  @override
  List<Object?> get props => [];

}

class CalendarLoadingState extends CalendarState {

  @override
  List<Object?> get props => [];
}

class CalendarErrorState extends CalendarState {
  final String error;

  CalendarErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}