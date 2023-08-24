import 'package:flutter/material.dart';

class ElevatedBtnTemplate extends StatelessWidget {
  final String text;
  final VoidCallback func;

  const ElevatedBtnTemplate({super.key, required this.text, required this.func});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.secondary),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
                vertical: 18.0, horizontal: 18.0),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
      ),
      onPressed: func,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary
        ),
      ),
    );
  }
}