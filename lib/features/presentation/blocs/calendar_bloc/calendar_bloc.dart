import 'package:avlo/core/models/calendar_model.dart';
import 'package:avlo/core/service/api/get_calendar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/get_it.dart';
import 'calendar_state.dart';


class CalendarInitEvent extends Equatable {

  final String date;

  CalendarInitEvent({required this.date});

  @override
  List<Object?> get props => [];

}

class CalendarBloc extends Bloc<CalendarInitEvent, CalendarState> {
  CalendarBloc(CalendarState initialState) : super(initialState) {

    on<CalendarInitEvent>((event, emit) async {
      emit(CalendarLoadingState());

      try {
        final CalendarModel calendar = await getIt.get<GetCalendar>().getCalendar(date: event.date);

        emit(CalendarInitState(calendar: calendar));

      }catch (error) {
        print(error);
        emit(CalendarErrorState(error: error.toString()));
      }

    });
  }

}