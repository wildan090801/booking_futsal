import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/customer_card_history.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';

class CustomerHistoryScreen extends StatelessWidget {
  const CustomerHistoryScreen({super.key});

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
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          children: const [
            CustomerCardHistory(
              statusTransaksi: 'Berhasil',
              jadwalBooking: 'Kamis 09-08-2001',
              jamMulai: '10:00 WIB',
              jenisLapangan: 'Lapangan Futsal 1',
              tanggalTransaksi: '07-08-2001',
            ),
            CustomerCardHistory(
              statusTransaksi: 'Gagal',
              jadwalBooking: 'Kamis 09-08-2001',
              jamMulai: '10:00 WIB',
              jenisLapangan: 'Lapangan Futsal 1',
              tanggalTransaksi: '07-08-2001',
            ),
          ],
        ),
      ),
    );
  }
}
