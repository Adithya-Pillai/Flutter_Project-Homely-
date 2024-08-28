import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(238, 221, 198, 1),
      child: const Center(
        child: SpinKitPumpingHeart(
          color: Color.fromRGBO(201, 160, 112, 1),
          size: 50,
        ),
      ),
    );
  }
}
