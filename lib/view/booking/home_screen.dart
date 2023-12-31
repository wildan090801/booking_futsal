import 'package:booking_futsal/controller/field_controller.dart';
import 'package:booking_futsal/model/field_model.dart';
import 'package:booking_futsal/state/state_management.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<FieldModel>>(
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
                  onTap: () =>
                      ref.read(selectedField.notifier).state = fields[index],
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
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
                              InkWell(
                                onTap: () {
                                  ref.read(selectedField.notifier).state =
                                      fields[index];
                                  Navigator.pushNamed(
                                      context, '/booking-screen');
                                },
                                child: Container(
                                  width: 120,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Booking',
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
    );
  }
}
