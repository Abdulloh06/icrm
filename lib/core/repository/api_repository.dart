/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


class ApiRepository {
  static const String baseUrl = 'https://avlocrm-api.eurosoft.site/api/';
  static const String appUrl = 'https://avlolead.page.link';
  static const String botToken = '5038327212:AAHlxI6_ZtrV93_J1vy0xMKXGKisnIxQ6y8';
  static const String login = baseUrl + 'login';
  static const String registerStepOne = baseUrl + 'step-one';
  static const String registerStepTwo = baseUrl + 'step-two';
  static const String registerConfirmation = baseUrl + 'step-confirmation';
  static const String getUser = baseUrl + 'users';
  static const String getYandexMail =
      'https://oauth.yandex.ru/authorize?response_type=token&client_id=0bfbf1a8f5b049cbb11f40406e6123c9';
  static const String projectMembers = baseUrl + 'project-members';
  static const String getCompany = baseUrl + 'companies';
  static const String getLeadsStatus = baseUrl + 'lead-statuses';
  static const String getContacts = baseUrl + 'contacts';
  static const String getProjects = baseUrl + 'projects';
  static const String getUserCategories = baseUrl + 'user-categories';
  static const String getNotes = baseUrl + "notes";
  static const String getProfile = baseUrl + "me";
  static const String getDashboard = baseUrl + "leads-board";
  static const String getProjectStatuses = baseUrl + "project-statuses";
  static const String getLeads = baseUrl + "leads";
  static const String getTasks = baseUrl + "tasks";
  static const String getAttachment = baseUrl + "attachments";
  static const String getPortfolio = baseUrl + "portfolio";
  static const String getTaskStatuses = baseUrl + "task-statuses";
  static const String getCalendar = baseUrl + "calendar";
  static const String task_users = baseUrl + "task-users";
  static const String social_auth = baseUrl + "auth-social";
  static const String getUsers = baseUrl + "users";
  static const String changePassword = baseUrl + "password";
  static const String inviteUser = baseUrl + "invite-user";
  static const String leadsMessage = baseUrl + "lead-messages";
}
