class BookingModel {
  String? fieldName = '', image = '';

  BookingModel({this.fieldName, this.image});

  BookingModel.fromJson(Map<String?, dynamic> json) {
    image = json['image'];
    fieldName = json['fieldName'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    // ignore: unnecessary_this
    data['image'] = this.image;
    // ignore: unnecessary_this
    data['fieldName'] = this.fieldName;
    return data;
  }
}
