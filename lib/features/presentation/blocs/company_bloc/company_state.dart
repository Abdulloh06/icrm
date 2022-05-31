/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

class CompanyInitState extends CompanyState {

  final List<CompanyModel> companies;

  CompanyInitState({required this.companies});

  @override
  List<Object?> get props => [companies];
}

class CompanyAddState extends CompanyState {
  final CompanyModel company;

  CompanyAddState({required this.company});

  @override
  List<Object?> get props => [company];
}

class CompanyShowState extends CompanyState {
  final CompanyModel company;

  CompanyShowState({required this.company});
}

class CompanyLoadingState extends CompanyState {}

class CompanyErrorState extends CompanyState {
  final String error;

  CompanyErrorState({required this.error});
}
