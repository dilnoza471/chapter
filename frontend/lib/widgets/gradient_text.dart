import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
