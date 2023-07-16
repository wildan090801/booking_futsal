import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Stream<List<FieldModel>> getFieldsStream() {
  return FirebaseFirestore.instance
      .collection('bookings')
      .orderBy('fieldName', descending: false)
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => FieldModel.fromJson(doc.data()))
            .toList(),
      );
}

Future<void> deleteField(BuildContext context, String documentId) async {
  try {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(documentId)
        .delete();
    // ignore: use_build_context_synchronously
    showSuccessPopupFlushbar(context, 'Berhasil menghapus data lapangan');
  } catch (e) {
    showErrorPopupFlushbar(
        context, 'Terjadi kesalahan dalam menghapus lapangan');
  }
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
    Text('Gagal mengambil data time slots: $error');
  }

  return result;
}
