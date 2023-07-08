class FieldModel {
  String? fieldName = '', image = '', docId = '';

  FieldModel({this.fieldName, this.image, this.docId});

  FieldModel.fromJson(Map<String?, dynamic> json) {
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
