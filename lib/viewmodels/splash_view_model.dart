import 'dart:async';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier{

  Future<void> startSplash(
    Function onComplete,
  ) async {

    Timer(
      const Duration(seconds: 3),
      () {
        onComplete();
      },
    );
  }
}