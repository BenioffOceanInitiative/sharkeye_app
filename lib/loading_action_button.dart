import 'package:flutter/material.dart';

class LoadingActionButton extends StatefulWidget {
  const LoadingActionButton({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  final Function() onPressed;
  final IconData iconData;

  @override
  State<LoadingActionButton> createState() => _LoadingActionButtonState();
}

class _LoadingActionButtonState extends State<LoadingActionButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        await widget.onPressed();

        setState(() {
          isLoading = false;
        });
      },
      icon: isLoading
          ? const CircularProgressIndicator()
          : Icon(
              widget.iconData,
            ),
    );
  }
}
