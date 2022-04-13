import 'package:icrm/core/models/portfolio_model.dart';
import 'package:equatable/equatable.dart';

abstract class PortfolioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PortfolioInitState extends PortfolioState {

  final List<PortfolioModel> list;

  PortfolioInitState({required this.list});


  @override
  List<Object?> get props => [];
}

class PortfolioLoadingState extends PortfolioState {}

class PortfolioErrorState extends PortfolioState {
  final String error;

  PortfolioErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}