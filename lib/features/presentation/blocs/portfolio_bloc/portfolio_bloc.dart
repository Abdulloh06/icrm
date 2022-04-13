import 'package:icrm/core/models/portfolio_model.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_event.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/api/get_portfolio.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(PortfolioState initialState) : super(initialState) {
    on<PortfolioInitEvent>((event, emit) async {

      emit(PortfolioLoadingState());

      try {

        List<PortfolioModel> list = await getIt.get<GetPortfolio>().getPortfolio();

        emit(PortfolioInitState(list: list));

      } catch(e) {
        print(e);
        emit(PortfolioErrorState(error: e.toString()));
      }

    });
  }
}