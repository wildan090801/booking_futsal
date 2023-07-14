class UserModel {
  String? name = '', email = '', password = '', role = '';
  bool isAdmin = false;

  UserModel({
    this.name,
    this.email,
  });

  UserModel.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['role'];
    isAdmin = json['isAdmin'] == null ? false : json['isAdmin'] as bool;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['role'] = role;
    data['isAdmin'] = isAdmin;
    return data;
  }
}
