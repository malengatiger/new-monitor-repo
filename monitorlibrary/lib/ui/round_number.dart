import 'package:flutter/material.dart';

import '../functions.dart';

class RoundNumber extends StatelessWidget {
  final int number;
  final double? height, width;
  final Color? color;
  final TextStyle? textStyle;

  const RoundNumber(this.number,
      {required this.height, required this.width, required this.color, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 32.0 : height,
      width: width == null ? 32.0 : width,
      color: color == null ? Colors.white : color,
      child: Center(
        child: Text(
          '$number',
          style: textStyle == null ? Styles.whiteTiny : textStyle,
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
    );
  }
}
