import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PortfolioInitEvent extends PortfolioEvent{}
