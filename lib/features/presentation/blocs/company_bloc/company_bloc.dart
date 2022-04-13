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
    on<CompanyInitEvent>((event, emit) async {
      try {
        final List<CompanyModel> company = await getIt.get<GetCompany>().getCompany();
        emit(CompanyInitState(companies: company));
      } catch (e, stacktrace) {
        print(stacktrace);
        print(e);
        emit(CompanyErrorState(error: e.toString()));
      }
    });

    on<CompanyAddEvent>((event, emit) async {
      try {
        CompanyModel company = await getIt.get<GetCompany>().addCompany(
          name: event.name,
          logo: event.image,
          contactId: event.contactId,
          url: event.url,
          description: event.description,
        );

        emit(CompanyAddState(company: company));

      } catch (e) {
        print(e);
        emit(CompanyErrorState(error: e.toString()));
      }
    });


    on<CompanyUpdateEvent>((event, emit) async {
      emit(CompanyLoadingState());

      try {
        CompanyModel company = await getIt.get<GetCompany>().updateCompany(
          id: event.id,
          name: event.name,
          description: event.description,
          site_url: event.url,
          logo: event.logo,
          contact_id: event.contact_id,
          hasLogo: event.hasLogo,
        );

        final CompanyModel companyModel = await getIt.get<GetCompany>().showCompany(id: event.id);

        emit(CompanyShowState(company: companyModel));

      } catch (error) {
        print(error);

        emit(CompanyErrorState(error: error.toString()));
      }
    });

    on<CompanyShowEvent>((event, emit) async {
      emit(CompanyLoadingState());

      try {
        CompanyModel company = await getIt.get<GetCompany>().showCompany(id: event.id);

        emit(CompanyShowState(company: company));

      } catch(error) {
        print(error);

        emit(CompanyErrorState(error: error.toString()));
      }

    });
  }
}
