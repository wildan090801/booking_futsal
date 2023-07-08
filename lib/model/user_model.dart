class UserModel {
  String? name = '', email = '';
  bool isAdmin = false;

  UserModel({
    this.name,
    this.email,
  });

  UserModel.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    name = json['name'];
    isAdmin = json['isAdmin'] == null ? false : json['isAdmin'] as bool;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['isAdmin'] = isAdmin;
    return data;
  }
}
