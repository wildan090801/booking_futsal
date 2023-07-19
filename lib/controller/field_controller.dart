import 'dart:io';

import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class FieldController {
  static Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(imageFile);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addField(
    BuildContext context,
    TextEditingController fieldNameController,
    File? image,
    GlobalKey<FormState> formKey,
  ) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final fieldName = fieldNameController.text;

      if (image != null) {
        final imageUrl = await _uploadImage(image);

        if (imageUrl != null) {
          final newField = FieldModel(fieldName: fieldName, image: imageUrl);

          final docRef = FirebaseFirestore.instance
              .collection('bookings')
              .doc(fieldName.replaceAll(" ", ""));
          try {
            await docRef.set(newField.toJson());
            fieldNameController.clear();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            showSuccessPopupFlushbar(
                context, 'Berhasil menambahkan data lapangan');
          } catch (e) {
            // ignore: use_build_context_synchronously
            showErrorPopupFlushbar(
                context, 'Terjadi kesalahan dalam menambahkan lapangan');
          }
        } else {
          // ignore: use_build_context_synchronously
          showErrorPopupFlushbar(
              context, 'Terjadi kesalahan dalam menambahkan lapangan');
        }
      } else {
        showErrorPopupFlushbar(context, 'Gambar tidak boleh kosong!');
      }
    }
  }

  static void editField(
    BuildContext context,
    TextEditingController fieldNameController,
    File? image,
    GlobalKey<FormState> formKey,
    FieldModel oldField,
  ) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final fieldName = fieldNameController.text;

      if (image != null) {
        final imageUrl = await _uploadImage(image);

        if (imageUrl != null) {
          final updatedField = FieldModel(
            fieldName: fieldName,
            image: imageUrl,
          );

          final docRef = FirebaseFirestore.instance.collection('bookings');

          try {
            await docRef
                .doc(oldField.fieldName!.replaceAll(" ", ""))
                .update(updatedField.toJson());

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            showSuccessPopupFlushbar(
                context, 'Berhasil memperbarui data lapangan');
          } catch (e) {
            // ignore: use_build_context_synchronously
            showErrorPopupFlushbar(
                context, 'Terjadi kesalahan dalam memperbarui lapangan');
          }
        } else {
          // ignore: use_build_context_synchronously
          showErrorPopupFlushbar(
              context, 'Terjadi kesalahan dalam memperbarui lapangan');
        }
      } else {
        showErrorPopupFlushbar(context, 'Gambar tidak boleh kosong!');
      }
    }
  }

  static Stream<List<FieldModel>> getFields() {
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

  static Future<void> deleteField(
      BuildContext context, String documentId) async {
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

  static Future<List<int>> getTimeSlotOfField(
      FieldModel fieldModel, String date) async {
    List<int> result = [];
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('fieldName', isEqualTo: fieldModel.fieldName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var bookingRef = snapshot.docs.first.reference.collection(date).get();
        var bookingSnapshot = await bookingRef;

        for (var doc in bookingSnapshot.docs) {
          var slot = int.tryParse(doc.id);
          if (slot != null) {
            result.add(slot);
          }
        }
      }
    } catch (error) {
      Text('Gagal mengambil data time slots: $error');
    }

    return result;
  }
}
