import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/card_manage_customer.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Data Pelanggan',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-customer');
            },
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 2,
                    bottom: 0,
                    child: Icon(
                      Icons.search,
                      color: greyColor,
                    ),
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 14),
                    onTap: () {},
                    decoration: InputDecoration(
                        hintText: 'Cari nama pelanggan...',
                        hintStyle: greyTextStyle,
                        contentPadding: const EdgeInsets.only(
                          top: 15,
                          bottom: 6,
                          left: 35,
                          right: 15,
                        ),
                        isDense: true,
                        border: InputBorder.none),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          children: const [
            CardManageCustomer(
              idPelanggan: 'ID-001',
              namaPelanggan: 'Muhammad Wildhan Kusumawardana',
              emailPelanggan: 'muhammadwildhan@gmail.com',
            ),
            CardManageCustomer(
              idPelanggan: 'ID-002',
              namaPelanggan: 'Lee Ji Eun',
              emailPelanggan: 'dlwlrma@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}
