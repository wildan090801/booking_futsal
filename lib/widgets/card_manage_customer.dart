import 'package:booking_futsal/model/user_model.dart';
import 'package:booking_futsal/service/user_ref.dart';
import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class CardManageCustomer extends StatelessWidget {
  const CardManageCustomer({
    Key? key,
    required this.userModel,
    required this.onUpdate,
  }) : super(key: key);

  final UserModel userModel;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userModel.role == 'pelanggan' ? 'Pelanggan' : 'Pengurus',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PopupMenuButton<MenuItem>(
                  color: Colors.white,
                  onSelected: (MenuItem item) {
                    if (item == MenuItem.edit) {
                      onUpdate();
                    } else if (item == MenuItem.delete) {
                      showDeleteDialog(context, () {
                        deleteUser(context, userModel.email!);
                        Navigator.pop(context);
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItem>>[
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.edit,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Ubah',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.delete,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Hapus',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, top: 20, right: 12, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            'Nama ${userModel.role == 'pelanggan' ? 'Pelanggan' : 'Pengurus'}',
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            userModel.name ?? '',
                            style: blackTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            'Email ${userModel.role == 'pelanggan' ? 'Pelanggan' : 'Pengurus'}',
                            style: blackTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            userModel.email ?? '',
                            style: blackTextStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum MenuItem {
  edit,
  delete,
}
