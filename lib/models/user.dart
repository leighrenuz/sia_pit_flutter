class User {
  final String email;
  final String password;


  User(this.email, this.password);
}


class UserRepository {
  static List<User> users = [];
}
