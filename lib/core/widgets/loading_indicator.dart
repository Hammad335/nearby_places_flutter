import 'package:flutter/material.dart';

class LoadingIndication extends StatelessWidget {
  const LoadingIndication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
