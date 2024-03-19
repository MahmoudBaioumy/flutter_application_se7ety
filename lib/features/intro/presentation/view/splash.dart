import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/features/intro/presentation/view/onboarding.dart';
import 'package:flutter_application_se7ety/features/patient/Home/presentaion/nav_par.dart';

class SlpashView extends StatefulWidget {
  const SlpashView({super.key});

  @override
  State<SlpashView> createState() => _SlpashViewState();
}

class _SlpashViewState extends State<SlpashView> {
  User? user;
  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              (user != null) ? const PatientMainPage() : const OnboardingView(),
        ));
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
