import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.controller,
    required this.title,
    this.isPassword = false,
    required this.hintText,
    this.isEdit = false,
    String? Function(String? value)? validator,
  });

  final TextEditingController? controller;
  final String title;
  final bool isPassword;
  final String hintText;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          readOnly: isEdit,
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
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
            fillColor: isEdit == true ? Colors.black12 : whiteColor,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
