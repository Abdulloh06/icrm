/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';
import 'package:icrm/core/models/portfolio_model.dart';

abstract class PortfolioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PortfolioInitEvent extends PortfolioEvent {}

class PortfolioGetNextPageEvent extends PortfolioEvent {
  static int page = 1;
  static bool hasReachedMax = false;
  final List<PortfolioModel> list;

  PortfolioGetNextPageEvent({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}
