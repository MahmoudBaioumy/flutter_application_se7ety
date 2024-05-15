import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/tile_widget.dart';
import 'package:flutter_application_se7ety/features/doctor/profile/userSettings.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key});

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<DoctorProfileView> {
  String? _imagePath;
  File? file;
  String? profileUrl;

  String? userId;

  Future<void> _getUser() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://se7ety-f02b3.appspot.com')
            .ref()
            .child('doctor/${FirebaseAuth.instance.currentUser!.uid}');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!, 'doc');
    FirebaseFirestore.instance.collection('doctor').doc(userId).set({
      'image': profileUrl,
    }, SetOptions(merge: true));
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
        backgroundColor: AppColor.bluecolor,
        elevation: 0,
        title: const Text(
          'الحساب الشخصي',
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.settings,
              color: AppColor.white1color,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => const User_Settings()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctor')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppColor.white1color,
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.white1color,
                                    radius: 60,
                                    backgroundImage: (userData?['image'] != '')
                                        ? NetworkImage(userData?['image'])
                                        : (_imagePath != null)
                                            ? FileImage(File(_imagePath!))
                                                as ImageProvider
                                            : const AssetImage(
                                                'assets/doc.png'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _pickImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 20,
                                      // color: AppColors.color1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userData!['name']}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTitelstyle(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    userData['specialization'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getBodystyle(),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "نبذه تعريفيه",
                          style: getBodystyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userData['bio'] == '' ? 'لم تضاف' : userData['bio'],
                          style: getsmallstyle(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "معلومات التواصل",
                          style: getBodystyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TileWidget(
                                  text: userData['email'] ?? 'لم تضاف',
                                  icon: Icons.email),
                              const SizedBox(
                                height: 15,
                              ),
                              TileWidget(
                                  text: userData['phone1'], icon: Icons.call),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TileWidget(
                                  text:
                                      '${userData['openHour']}:00 - ${userData['closeHour']}:00',
                                  icon: Icons.email),
                              const SizedBox(
                                height: 15,
                              ),
                              TileWidget(
                                  text: userData['phone1'], icon: Icons.call),
                            ],
                          ),
                        ),
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
