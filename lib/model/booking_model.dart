class BookingModel {
  String? fieldName = '', image = '', docId = '';

  BookingModel({this.fieldName, this.image, this.docId});

  BookingModel.fromJson(Map<String?, dynamic> json) {
    image = json['image'];
    fieldName = json['fieldName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'image': image,
      'fieldName': fieldName,
    };
    return data;
  }
}
