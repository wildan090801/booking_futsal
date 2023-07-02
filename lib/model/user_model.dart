class UserModel {
  String? name = '', email = '';

  UserModel({required this.name, required this.email});

  UserModel.fromJson(Map<String?, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    // ignore: unnecessary_this
    data['email'] = this.email;
    // ignore: unnecessary_this
    data['name'] = this.name;
    return data;
  }
}
