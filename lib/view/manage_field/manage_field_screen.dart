import 'package:booking_futsal/controller/field_controller.dart';
import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/view/manage_field/edit_field_data_screen.dart';
import 'package:booking_futsal/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class ManageFieldScreen extends ConsumerWidget {
  const ManageFieldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Data Lapangan',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-field');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<FieldModel>>(
        stream: FieldController.getFields(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var fields = snapshot.data!;
            if (fields.isEmpty) {
              return const Center(
                child: Text('Tidak dapat memuat daftar lapangan'),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                        bottom: 5,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              fadeInDuration: const Duration(seconds: 1),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.maxFinite,
                                  height: 250,
                                  color: Colors.grey,
                                );
                              },
                              image: fields[index].image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fields[index].fieldName!,
                                  style: blackTextStyle.copyWith(
                                    fontSize: 20,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditFieldDataScreen(
                                              field: fields[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Ubah',
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDeleteDialog(context, () {
                                          FieldController.deleteField(
                                              context,
                                              fields[index]
                                                  .fieldName!
                                                  .replaceAll(" ", ""));
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Hapus',
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
