class TeamModel {
  final int id;
  final String first_name;
  final String last_name;
  final String username;
  final String phoneNumber;
  final String jobTitle;
  final String email;
  final dynamic social_avatar;
  final dynamic is_often;

  const TeamModel({
    required this.id,
    required this.last_name,
    required this.first_name,
    required this.phoneNumber,
    required this.email,
    required this.username,
    required this.jobTitle,
    required this.social_avatar,
    required this.is_often,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      phoneNumber: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      jobTitle: json['job_title'] ?? "",
      social_avatar: json['social_avatar'] ?? "",
      is_often: json['is_often'] ?? true,
    );
  }

  static List<TeamModel> fetchData(Map<String, dynamic> data) {

    List items = data['data'];
    List<TeamModel> team = [];

    for(int i = 0; i < items.length; i++) {
      team.add(TeamModel.fromJson(items[i]));
    }

    return team;
  }

}
