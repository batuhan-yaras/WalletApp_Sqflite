class UserModel {
  int? id;
  String? username;
  int? password;
  String? email;
  double? money;

  UserModel({this.id, this.username, this.password, this.email, this.money});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    money = json['money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['money'] = money;
    return data;
  }
}
