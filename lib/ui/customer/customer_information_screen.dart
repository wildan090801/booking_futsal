import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';

class CustomerInformationScreen extends StatelessWidget {
  const CustomerInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Informasi',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Harga Sewa Lapangan Futsal \n Hap Hap Sports',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Senin - Minggu',
                      style: blackTextStyle.copyWith(
                          fontSize: 14, fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Jam 08.00 - 15.00 = Rp. 85.000 \n\n Jam 16:00 - 22:00 = Rp. 100.000',
                      style: blackTextStyle.copyWith(
                          fontSize: 14, fontWeight: medium),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: greyColor,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Peraturan Penting!!!',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Keterlambatan melebihi 15 menit dari waktu booking maka booking otomatis batal!',
                      style: blackTextStyle.copyWith(
                          fontSize: 14, fontWeight: medium),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: greyColor,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Fasilitas Tersedia \n Hap Hap Sports',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('● Tempat Parkir', style: blackTextStyle),
                    Text('● WC / Kamar Mandi', style: blackTextStyle),
                    Text('● Ruang Ganti', style: blackTextStyle),
                    Text('● Mushola', style: blackTextStyle),
                    Text('● Warung Makanan dan Minuman', style: blackTextStyle),
                    Text('● Toko Perlengkapan Olahraga', style: blackTextStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
