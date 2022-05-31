/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/portfolio_model.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_event.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/api/get_portfolio.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(PortfolioState initialState) : super(initialState) {
    on<PortfolioInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<PortfolioGetNextPageEvent>((event, emit) => _getNextPage(event: event, emit: emit));
  }

  Future<void> _init({
    required PortfolioInitEvent event,
    required Emitter<PortfolioState> emit,
  }) async {
    emit(PortfolioLoadingState());

    try {

      PortfolioGetNextPageEvent.page = 1;
      PortfolioGetNextPageEvent.hasReachedMax = false;
      List<PortfolioModel> list = await getIt.get<GetPortfolio>().getPortfolio(page: 1);

      emit(PortfolioInitState(list: list));

    } catch(e) {
      print(e);
      emit(PortfolioErrorState(error: e.toString()));
    }
  }

  Future<void> _getNextPage({
    required PortfolioGetNextPageEvent event,
    required Emitter<PortfolioState> emit,
  }) async {

    try {

      PortfolioGetNextPageEvent.page++;

      List<PortfolioModel> list = await getIt.get<GetPortfolio>().getPortfolio(page: PortfolioGetNextPageEvent.page);

      if(list.isNotEmpty) {
        emit(PortfolioInitState(list: event.list + list));
      }else {
        PortfolioGetNextPageEvent.page--;
        PortfolioGetNextPageEvent.hasReachedMax = true;
        emit(PortfolioInitState(list: event.list));
      }
    } catch(e) {
      print(e);
      emit(PortfolioErrorState(error: "something_went_wrong"));
    }
  }
}