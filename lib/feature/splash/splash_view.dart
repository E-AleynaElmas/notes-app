// lib/feature/splash/splash_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:notes_app/feature/splash/splash_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.nonReactive(
      viewModelBuilder: () => SplashViewModel(),
      onViewModelReady: (vm) {
        // >>> EN ÖNEMLİ NOKTA: build bittikten SONRA başlat
        SchedulerBinding.instance.addPostFrameCallback((_) {
          vm.start();
        });
      },
      builder: (_, __, ___) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
