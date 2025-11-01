import 'package:flutter/material.dart';
import '../../../../utils/color.dart';

class OnBoardTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;

  const OnBoardTextButton(
      {Key? key, this.onPressed, required this.title, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? CircularProgressIndicator(
            color: Colors.black.withOpacity(0.3),
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ));
  }
}
