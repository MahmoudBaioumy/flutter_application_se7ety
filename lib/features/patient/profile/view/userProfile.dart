import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';
import 'package:flutter_application_se7ety/core/widget/tile_widget.dart';
import 'package:flutter_application_se7ety/features/patient/profile/appointments/appointmentHistoryList.dart';
import 'package:flutter_application_se7ety/features/patient/profile/view/userSettings.dart';
import 'package:image_picker/image_picker.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://se7ety-f02b3.appspot.com');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imagePath;
  File? file;
  String? profileUrl;

  User? user;
  String? UserID;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
    UserID = user?.uid;
  }

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
        _storage.ref().child('patients/${_auth.currentUser!.uid}$imageName');
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
    FirebaseFirestore.instance.collection('patient').doc(UserID).set({
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
        title: Text(
          'الحساب الشخصي',
          style: getTitelstyle(
            color: AppColor.white1color,
            fontSize: 20,
          ),
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
            onPressed: () async {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: 'mbaioumy84@gmail.com');
              Navigator.push(context,
                  MaterialPageRoute(builder: (contex) => const UserSettings()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('patient')
                .doc(user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userData = snapshot.data;
              print(userData!['name']);
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
                                    backgroundImage: (userData['image'] != null)
                                        ? NetworkImage(userData['image'])
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
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 20,
                                      color: AppColor.bluecolor,
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
                                    "${userData['name']}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTitelstyle(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  (userData['city'] == null)
                                      ? CustomButton(
                                          text: 'تعديل الحساب',
                                          height: 40,
                                          onPressed: () {},
                                        )
                                      : Text(
                                          userData['city'],
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
                          userData['bio'] ?? 'لم تضاف',
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
                            color: AppColor.white2color,
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
                                  text: userData['phone'] ?? 'لم تضاف',
                                  icon: Icons.call),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "حجوزاتي",
                          style: getBodystyle(fontWeight: FontWeight.w600),
                        ),
                        const AppointmentHistoryList()
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
