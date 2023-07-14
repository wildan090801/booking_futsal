import 'package:booking_futsal/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: whiteTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
        ),
      ),
    );
  }
}
