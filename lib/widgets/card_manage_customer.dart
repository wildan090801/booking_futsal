import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

class CardManageCustomer extends StatefulWidget {
  const CardManageCustomer({
    super.key,
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.emailPelanggan,
  });

  final String idPelanggan;
  final String namaPelanggan;
  final String emailPelanggan;

  @override
  State<CardManageCustomer> createState() => _CardManageCustomerState();
}

class _CardManageCustomerState extends State<CardManageCustomer> {
  MenuItem? selectedMenu;

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
                  widget.idPelanggan,
                  style:
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
                PopupMenuButton<MenuItem>(
                  color: whiteColor,
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (MenuItem item) {
                    setState(() {
                      selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItem>>[
                    PopupMenuItem<MenuItem>(
                      value: MenuItem.itemOne,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: blackColor,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Ubah',
                            style: blackTextStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<MenuItem>(
                      value: MenuItem.itemOne,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: blackColor,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Hapus',
                            style: blackTextStyle,
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Pelanggan',
                      style: blackTextStyle.copyWith(fontWeight: bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.namaPelanggan,
                      style: blackTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Email Pelanggan',
                      style: blackTextStyle.copyWith(fontWeight: bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.emailPelanggan,
                      style: blackTextStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum MenuItem {
  itemOne,
  itemTwo,
}
