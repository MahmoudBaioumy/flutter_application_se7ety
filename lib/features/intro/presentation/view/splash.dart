import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/features/intro/presentation/view/onboarding.dart';

class SlpashView extends StatefulWidget {
  const SlpashView({super.key});

  @override
  State<SlpashView> createState() => _SlpashViewState();
}

class _SlpashViewState extends State<SlpashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        pushwithReplacement(context, const OnboardingView());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/back.png',
          width: 250,
        ),
      ),
    );
  }
}
