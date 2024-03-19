import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/doctor_Card.dart';
import 'package:flutter_application_se7ety/features/auth/Data/doctor_model.dart';
import 'package:flutter_application_se7ety/features/patient/search/presentaion/view/doctor_profile.dart';
import 'package:flutter_svg/svg.dart';

class SearchHomeView extends StatefulWidget {
  final String searchKey;
  const SearchHomeView({super.key, required this.searchKey});

  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.bluecolor,
        title: Text(
          'ابحث عن دكتورك',
          style: getTitelstyle(color: AppColor.white1color),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .orderBy('name')
              .startAt([widget.searchKey]).endAt(
                  ['${widget.searchKey}\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data?.size == 0
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/no-search.svg',
                            width: 250,
                          ),
                          Text(
                            'لا يوجد دكتور بهذا الاسم',
                            style: getBodystyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scrollbar(
                    child: ListView.builder(
                      itemCount: snapshot.data?.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doctor = snapshot.data!.docs[index];
                        return DoctorCard(
                            name: doctor['name'],
                            image: doctor['image'],
                            specialization: doctor['specialization'],
                            rating: doctor['rating'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorProfile(
                                   doctor: DoctorModel(
                                    id: doctor.id,
                                    name: doctor['name'],
                                    image: doctor['image'],
                                    specialization: doctor['specialization'],
                                    rating: doctor['rating'],
                                    email: doctor['email'],
                                    phone1: doctor['phone1'],
                                    phone2: doctor['phone2'],
                                    bio: doctor['bio'],
                                    openHour: doctor['openHour'],
                                    closeHour: doctor['closeHour'],
                                    address: doctor['address'],
                                  ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  );
          },
        ),
      ),
    );
  }
}
