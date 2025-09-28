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
      onViewModelReady: (viewModel) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          viewModel.start();
        });
      },
      builder: (context, viewModel, child) => const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
