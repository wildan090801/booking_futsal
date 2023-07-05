class UserModel {
  String? name = '', email = '', role = '';

  UserModel({this.name, this.email, this.role});

  UserModel.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    name = json['name'];
    role = json['role'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['role'] = role;
    return data;
  }
}
