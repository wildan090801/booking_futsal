import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/admin_card_history.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';

class AdminHistoryScreen extends StatelessWidget {
  const AdminHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Riwayat',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month),
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
            AdminCardHistory(
              namaPelanggan: 'Muhammad Wildhan',
              jadwalBooking: 'Kamis 09-08-2001',
              jamMulai: '10:00 WIB',
              jenisLapangan: 'Lapangan Futsal 1',
              tanggalTransaksi: '09-09-2023',
            ),
            AdminCardHistory(
              namaPelanggan: 'Muhammad NadLiw',
              jadwalBooking: 'Kamis 09-08-2001',
              jamMulai: '10:00 WIB',
              jenisLapangan: 'Lapangan Futsal 1',
              tanggalTransaksi: '07-07-2023',
            ),
          ],
        ),
      ),
    );
  }
}
