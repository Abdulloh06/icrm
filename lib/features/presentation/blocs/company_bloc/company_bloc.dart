/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/company_model.dart';
import 'package:icrm/core/service/api/get_company.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/util/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc(CompanyState initialState) : super(initialState) {
    on<CompanyInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<CompanyAddEvent>((event, emit) => _addCompany(event: event, emit: emit));
    on<CompanyUpdateEvent>((event, emit) => _updateCompany(event: event, emit: emit));
    on<CompanyShowEvent>((event, emit) => _showCompany(event: event, emit: emit));
  }

  Future<void> _init({
    required CompanyInitEvent event,
    required Emitter<CompanyState> emit,
  }) async {
    try {
      final List<CompanyModel> company = await getIt.get<GetCompany>().getCompany();
      emit(CompanyInitState(companies: company));
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e);
      emit(CompanyErrorState(error: e.toString()));
    }
  }

  Future<void> _addCompany({
    required CompanyAddEvent event,
    required Emitter<CompanyState> emit,
  }) async {
    emit(CompanyLoadingState());

    try {
      var company = await getIt.get<GetCompany>().addCompany(
        name: event.name,
        logo: event.image,
        contactId: event.contactId,
        url: event.url,
        description: event.description,
      );

      if(company is String) {
        emit(CompanyErrorState(error: company));
      }else {
        emit(CompanyAddState(company: company as CompanyModel));
      }

    } catch (e) {
      emit(CompanyErrorState(error: e.toString()));
    }
  }

  Future<void> _updateCompany({
    required CompanyUpdateEvent event,
    required Emitter<CompanyState> emit,
  }) async {
    emit(CompanyLoadingState());

    try {
      CompanyModel company = await getIt.get<GetCompany>().updateCompany(
        id: event.id,
        name: event.name,
        description: event.description,
        site_url: event.url,
        logo: event.logo,
        contact_id: event.contact_id,
      );


      final CompanyModel companyModel = await getIt.get<GetCompany>().showCompany(id: company.id);

      emit(CompanyShowState(company: companyModel));

    } catch (error) {
      print(error);

      emit(CompanyErrorState(error: error.toString()));
    }
  }

  Future<void> _showCompany({
    required CompanyShowEvent event,
    required Emitter<CompanyState> emit,
  }) async {
    emit(CompanyLoadingState());

    try {
      CompanyModel company = await getIt.get<GetCompany>().showCompany(id: event.id);

      emit(CompanyShowState(company: company));

    } catch(error) {
      print(error);

      emit(CompanyErrorState(error: error.toString()));
    }
  }

}
