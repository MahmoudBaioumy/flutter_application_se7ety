import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_dialogs.dart';
import 'package:flutter_application_se7ety/features/auth/Data/doctor_model.dart';
import 'package:flutter_application_se7ety/features/auth/Data/specialization.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_Cubit.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_states.dart';
import 'package:flutter_application_se7ety/features/patient/Home/presentaion/nav_par.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone1 = TextEditingController();
  final TextEditingController _phone2 = TextEditingController();
  String _specialization = specialization[0];

  late String _startTime =
      DateFormat('hh').format(DateTime(2023, 9, 7, 10, 00));
  late String _endTime = DateFormat('hh').format(DateTime(2023, 9, 7, 22, 00));

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imagePath;
  File? file;
  String? profileUrl;

  User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  // 1) instance from FirebaseStorage with bucket Url..
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://se7ety-f02b3.appspot.com');

  // method to upload and get link of image
  Future<String> uploadImageToFireStore(File image) async {
    //2) choose file location (path)
    var ref = _storage.ref().child('doctors/${_auth.currentUser!.uid}');
    //3) choose file type (image/jpeg)
    var metadata = SettableMetadata(contentType: 'image/jpeg');
    // 4) upload image to Firebase Storage
    await ref.putFile(image, metadata);
    // 5) get image url
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
        // to upload the file (image) to firebase storage
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCuibt, AuthStates>(
      listener: (context, state) {
        if (state is UploaddataSuccessStates) {
          pushAndRemoveUntil(context, const PatientMainPage());
        } else if (state is UploaddataErorrStates) {
          Navigator.pop(context);
          showErrorDialog(context, state.Erorr);
        } else {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.bluecolor,
          title: Text(
            'إكمال عملية التسجيل',
            style: getTitelstyle(color: AppColor.white1color),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            // backgroundColor: AppColors.lightBg,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: (_imagePath != null)
                                  ? FileImage(File(_imagePath!))
                                      as ImageProvider
                                  : const AssetImage('assets/doc.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _pickImage();
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                // color: AppColors.color1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Row(
                          children: [
                            Text(
                              'التخصص',
                              style: getBodystyle(color: AppColor.blackcolor),
                            )
                          ],
                        ),
                      ),
                      // choose your Specialization
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColor.white2color,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: AppColor.bluecolor,
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: _specialization,
                          onChanged: (String? newValue) {
                            setState(() {
                              _specialization = newValue ?? specialization[0];
                            });
                          },
                          items: specialization.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'نبذة تعريفية',
                              style: getBodystyle(color: AppColor.blackcolor),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: _bio,
                        style: TextStyle(color: AppColor.blackcolor),
                        decoration: InputDecoration(
                            hintText:
                                'سجل المعلومات الطبية العامة مثل تعليمك الأكاديمي وخبراتك السابقة...',
                            hintStyle: getsmallstyle()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل النبذة التعريفية';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'عنوان العيادة',
                              style: getBodystyle(color: AppColor.blackcolor),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _address,
                        style: TextStyle(color: AppColor.blackcolor),
                        decoration: InputDecoration(
                            hintText: '5 شارع مصدق - الدقي - الجيزة',
                            hintStyle: getsmallstyle()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل عنوان العيادة';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'ساعات العمل من',
                                    style: getBodystyle(
                                        color: AppColor.blackcolor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'الي',
                                    style: getBodystyle(
                                        color: AppColor.blackcolor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // ---------- Start Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showStartTimePicker();
                                    },
                                    icon: Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColor.bluecolor,
                                    )),
                                hintText: _startTime,
                              ),
                            ),
                          ),
                          const Gap(10),

                          // ---------- End Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showEndTimePicker();
                                    },
                                    icon: Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColor.bluecolor,
                                    )),
                                hintText: _endTime,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 1',
                              style: getBodystyle(color: AppColor.blackcolor),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _phone1,
                        style: TextStyle(color: AppColor.blackcolor),
                        decoration: InputDecoration(
                            hintText: '+20xxxxxxxxxx',
                            hintStyle: getsmallstyle()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الرقم';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 2 (اختياري)',
                              style: getBodystyle(color: AppColor.blackcolor),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _phone2,
                        style: TextStyle(color: AppColor.blackcolor),
                        decoration: InputDecoration(
                            hintText: '+20xxxxxxxxxx',
                            hintStyle: getsmallstyle()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCuibt>().uploadDoctorData(DoctorModel(
                      id: user!.uid,
                      name: user?.displayName ?? '',
                      image: profileUrl ?? '',
                      specialization: _specialization,
                      rating: 3,
                      email: user!.email!,
                      phone1: _phone1.text,
                      phone2: _phone2.text,
                      bio: _bio.text,
                      openHour: _startTime,
                      closeHour: _endTime,
                      address: _address.text));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.bluecolor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "التسجيل",
                style: getTitelstyle(fontSize: 16, color: AppColor.white1color),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showStartTimePicker() async {
    final datePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // builder: (context, child) {
      //   return Theme(
      //     data: ThemeData(
      //       timePickerTheme: TimePickerThemeData(
      //           helpTextStyle: TextStyle(color: AppColors.color1),
      //           backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      //       colorScheme: ColorScheme.light(
      //         background: Theme.of(context).scaffoldBackgroundColor,
      //         primary: AppColors.color1, // header background color
      //         secondary: AppColors.black,
      //         onSecondary: AppColors.black,
      //         onPrimary: AppColors.black, // header text color
      //         onSurface: AppColors.black, // body text color
      //         surface: AppColors.black, // body text color
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(
      //           foregroundColor: AppColors.color1, // button text color
      //         ),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    if (datePicked != null) {
      setState(() {
        _startTime = datePicked.hour.toString();
      });
    }
  }

  showEndTimePicker() async {
    final timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );

    if (timePicker != null) {
      setState(() {
        _endTime = timePicker.hour.toString();
      });
    }
  }
}
