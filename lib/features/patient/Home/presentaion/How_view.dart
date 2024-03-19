import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/features/patient/Home/presentaion/search_%20home_view.dart';
import 'package:flutter_application_se7ety/features/patient/Home/widgets/Special_list.dart';
import 'package:flutter_application_se7ety/features/patient/Home/widgets/top_rated.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PatientHomePage> {
  final TextEditingController _doctorName = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Text("احجز الآن وكن جزءًا من رحلتك الصحية.",
                  style:
                      getTitelstyle(color: AppColor.blackcolor, fontSize: 25)),
              const SizedBox(height: 15),

              // --------------- Search Bar --------------------------
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    )
                  ],
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: _doctorName,
                  decoration: InputDecoration(
                    hintStyle: getBodystyle(),
                    filled: true,
                    hintText: 'ابحث عن دكتور',
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: AppColor.bluecolor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        splashRadius: 20,
                        color: Colors.white,
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(
                            () {
                              _doctorName.text.isEmpty
                                  ? Container()
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SearchHomeView(
                                          searchKey: _doctorName.text,
                                        ),
                                      ),
                                    );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  style: getBodystyle(),
                  onFieldSubmitted: (String value) {
                    setState(
                      () {
                        _doctorName.text.isEmpty
                            ? Container()
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchHomeView(
                                    searchKey: _doctorName.text,
                                  ),
                                ),
                              );
                      },
                    );
                  },
                ),
              ),
              const Gap(10),
              // ----------------  SpecialistsWidget --------------------,

              const SpecialistsBanner(),
              Gap(10),

              // ----------------  Top Rated --------------------,
              Text(
                "الأعلي تقييماً",
                textAlign: TextAlign.center,
                style: getTitelstyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const TopRatedList(),
            ],
          ),
        ),
      ),
    );
  }
}
