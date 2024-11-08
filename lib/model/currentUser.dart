class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;

  int? id;
  String? username;
  String? email;
  String? role;

  CurrentUser._internal();

  void setUser(int id, String username, String email, String role) {
    this.id = id;
    this.username = username;
    this.email = email;
    this.role = role;
  }

  void clearUser() {
    id = null;
    username = null;
    email = null;
    role = null;
  }
}
