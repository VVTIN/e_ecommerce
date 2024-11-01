class CurrentUser {
  static CurrentUser instance = CurrentUser._internal();
  factory CurrentUser() => instance;
  CurrentUser._internal();

  int? id;
  String? username;
  String? email;

 void setUser(int userId, String userName, String userEmail) {
  id = userId;
  username = userName;
  email = userEmail;
  print("CurrentUser set with id: $id, username: $username, email: $email");
}

void clearUser() {
  print("Clearing CurrentUser: id was $id, username was $username, email was $email");
  id = null;
  username = null;
  email = null;
}
}
