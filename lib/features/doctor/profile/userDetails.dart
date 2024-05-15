import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';

class User_Details extends StatefulWidget {
  const User_Details({super.key});

  @override
  _User_DetailsState createState() => _User_DetailsState();
}

class _User_DetailsState extends State<User_Details> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List labelName = [
    "الاسم",
    "رقم الهاتف",
    "المدينة",
    "نبذه تعريفية",
    "التخصصص"
  ];

  List value = ["name", "phone1", "address", "bio", "specialization"];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            splashRadius: 25,
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.white1color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('اعدادات الحساب'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var userData = snapshot.data;
            return ListView(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                labelName.length,
                (index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          var con = TextEditingController(
                              text: userData?[value[index]] == ''
                                  ? 'لم تضاف'
                                  : userData?[value[index]]);
                          var form = GlobalKey<FormState>();
                          return SimpleDialog(
                            alignment: Alignment.center,
                            contentPadding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            children: [
                              Form(
                                key: form,
                                child: Column(
                                  children: [
                                    Text(
                                      'ادخل ${labelName[index]}',
                                      style: getBodystyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: con,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColor.white1color),
                                      // decoration: InputDecoration(
                                      //     hintText: value[index]),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'من فضلك ادخل ${labelName[index]}.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomButton(
                                      text: 'حفظ التعديل',
                                      onPressed: () {
                                        if (form.currentState!.validate()) {
                                          updateData(value[index], con.text);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.white2color,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            labelName[index],
                            style: getBodystyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            userData?[value[index]] == ''
                                ? 'Not Added'
                                : userData?[value[index]],
                            style: getBodystyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateData(String key, value) async {
    FirebaseFirestore.instance.collection('doctor').doc(user!.uid).set({
      key: value,
    }, SetOptions(merge: true));
    if (key.compareTo('name') == 0) {
      await user?.updateDisplayName(value);
    }
    Navigator.pop(context);
  }
}
