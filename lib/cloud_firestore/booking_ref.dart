import 'package:booking_futsal/model/field_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<FieldModel>> getFields() async {
  var fields = List<FieldModel>.empty(growable: true);
  var fieldRef = FirebaseFirestore.instance.collection('bookings');
  var snapshot = await fieldRef.get();
  for (var element in snapshot.docs) {
    fields.add(FieldModel.fromJson(element.data()));
  }
  return fields;
}

Future<List<int>> getTimeSlotOfField(FieldModel fieldModel, String date) async {
  List<int> result = [];
  try {
    var bookingRef = FirebaseFirestore.instance
        .collection('bookings')
        .where('fieldName', isEqualTo: fieldModel.fieldName)
        .limit(1)
        .get()
        .then(
            (snapshot) => snapshot.docs.first.reference.collection(date).get());

    QuerySnapshot snapshot = await bookingRef;
    for (var doc in snapshot.docs) {
      var slot = int.tryParse(doc.id);
      if (slot != null) {
        result.add(slot);
      }
    }
  } catch (error) {
    print('Error fetching time slots: $error');
  }

  return result;
}
