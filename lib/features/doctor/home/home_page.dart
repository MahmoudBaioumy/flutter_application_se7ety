import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DoctorHomeView> {
  User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              splashRadius: 20,
              icon:
                  Icon(Icons.notifications_active, color: AppColor.blackcolor),
              onPressed: () {},
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'صــــــحّـتــي',
          style: getTitelstyle(color: AppColor.blackcolor)
              .copyWith(fontFamily: GoogleFonts.notoKufiArabic().fontFamily),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: 'مرحبا، ',
                      style: getBodystyle(fontSize: 18),
                    ),
                    TextSpan(
                      text: user?.displayName,
                      style: getTitelstyle(),
                    ),
                  ],
                )),
                Text("الآن وكن جزءًا من رحلتك الصحية.",
                    style: getTitelstyle(
                        color: AppColor.blackcolor, fontSize: 25)),
                const Gap(50),
                Center(
                  child: Image.asset(
                    'assets/back.png',
                    width: 350,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
