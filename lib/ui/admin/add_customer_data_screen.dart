import 'package:booking_futsal/utils/theme.dart';
import 'package:booking_futsal/widgets/custom_button.dart';
import 'package:booking_futsal/widgets/custom_formfield.dart';
import 'package:booking_futsal/widgets/flushbar_widget.dart';
import 'package:booking_futsal/widgets/scroll_behavior_without_glow.dart';
import 'package:flutter/material.dart';

class AddCustomerDataScreen extends StatefulWidget {
  const AddCustomerDataScreen({super.key});

  @override
  State<AddCustomerDataScreen> createState() => _AddCustomerDataScreenState();
}

class _AddCustomerDataScreenState extends State<AddCustomerDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tambah Data',
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehaviorWithoutGlow(),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                CustomFormField(
                  controller: _nameController,
                  title: 'Nama Lengkap',
                  hintText: 'Masukkan Nama Lengkap',
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomFormField(
                  controller: _emailController,
                  title: 'Alamat Email',
                  hintText: 'Masukkan Alamat Email',
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomFormField(
                  controller: _passwordController,
                  title: 'Kata Sandi',
                  hintText: 'Masukkan Kata Sandi',
                  isPassword: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  text: 'Tambah',
                  onPressed: () {
                    Navigator.pop(context);
                    showSuccessPopupFlushbar(
                      context,
                      'Data Pelanggan Berhasil Ditambahkan.',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
