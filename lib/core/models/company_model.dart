import 'package:avlo/core/models/contacts_model.dart';

class CompanyModel {
  final int id;
  final String name;
  final String description;
  final String site_url;
  final dynamic contact_id;
  final String logo;
  final ContactModel? contact;

  CompanyModel({
    required this.id,
    required this.description,
    required this.name,
    required this.contact_id,
    required this.site_url,
    required this.logo,
    required this.contact,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {

    ContactModel? contactModel;
    if(json['contact'] != null) {
      contactModel = ContactModel.fromJson(json['contact']);
    }

    return CompanyModel(
      id: json['id'],
      description: json['description'] ?? "",
      name: json['name'] ?? "",
      contact_id: json['contact_id'],
      site_url: json['site_url'] ?? "",
      logo: json['logo'] ?? "",
      contact: contactModel,
    );
  }

  static List<CompanyModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<CompanyModel> companies = [];

    for(int i = 0; i < items.length; i ++) {
      companies.add(CompanyModel.fromJson(items[i]));
    }

    return companies;
  }
}
