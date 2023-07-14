import 'dart:io';

import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddFieldDataScreen extends StatefulWidget {
  const AddFieldDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFieldDataScreen> createState() => _AddFieldDataScreenState();
}

class _AddFieldDataScreenState extends State<AddFieldDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fieldNameController = TextEditingController();

  @override
  void dispose() {
    _fieldNameController.dispose();
    super.dispose();
  }

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      showErrorPopupFlushbar(context, e.toString());
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tambah Data Lapangan',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Upload Gambar Lapangan',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickImage();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: image != null
                          ? Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      pickImage();
                                    },
                                    child: const Text('Ubah Gambar'),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload,
                                    size: 120,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      pickImage();
                                    },
                                    child: const Text('Pilih Gambar'),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Nama Lapangan',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama lapangan harus diisi';
                      }
                      return null;
                    },
                    controller: _fieldNameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama lapangan',
                      hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: greyColor,
                          width: 0.1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: blueColor,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Tambah',
                    onPressed: () {
                      _addNewField();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addNewField() async {
    if (_formKey.currentState!.validate()) {
      final fieldName = _fieldNameController.text;

      if (image != null) {
        final imageUrl = await _uploadImage(image!);

        if (imageUrl != null) {
          final newField = FieldModel(fieldName: fieldName, image: imageUrl);

          final docRef = FirebaseFirestore.instance
              .collection('bookings')
              .doc(fieldName.replaceAll(" ", ""));
          try {
            await docRef.set(newField.toJson());
            _resetForm();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            _showSuccessPopup();
          } catch (e) {
            _showErrorPopup();
          }
        } else {
          _showErrorPopup();
        }
      } else {
        _showErrorPopup();
      }
    }
  }

  void _showSuccessPopup() {
    showSuccessPopupFlushbar(context, 'Berhasil menambahkan data lapangan');
  }

  void _showErrorPopup() {
    showErrorPopupFlushbar(
        context, 'Terjadi kesalahan dalam menambahkan lapangan');
  }

  void _resetForm() {
    _fieldNameController.clear();
    setState(() {
      image = null;
    });
  }

  Future<FieldModel?> addField(FieldModel field) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add(field.toJson());
      final docSnapshot = await docRef.get();
      final newField = FieldModel.fromJson(docSnapshot.data()!);
      return newField;
    } catch (e) {
      Text('Error adding field: $e');
      return null;
    }
  }
}