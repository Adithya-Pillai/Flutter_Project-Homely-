import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    Key? key,
    required this.text,
    this.size,
    this.colors,
    this.weight,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  final String text;
  final double? size;
  final Color? colors;
  final FontWeight? weight;
  TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: 1,
      style: TextStyle(
        fontSize: size ?? 16,
        color: colors ?? Colors.black,
        fontWeight: weight ?? FontWeight.w400,
        fontFamily: 'Poppins',
      ),
    );
  }
}
