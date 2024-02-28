import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/email_vaildate.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view/signup_view.dart';
import 'package:gap/gap.dart';

class login_view extends StatefulWidget {
  const login_view({super.key, required this.index});
  final int index;

  @override
  State<login_view> createState() => _login_viewState();
}

class _login_viewState extends State<login_view> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  bool isVisable = true;

  String handleUserType(int index) {
    return widget.index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/back.png',
                    width: 250,
                  ),
                  Text(
                    'سجل دخول الان كـ "${handleUserType(widget.index)}"',
                    style: getTitelstyle(),
                  ),
                  const Gap(25),
                  TextFormField(
                      textAlign: TextAlign.end,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'mahmoud baioumy@gmail,com',
                        hintStyle: getsmallstyle(),
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColor.bluecolor,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل الاميل';
                        } else if (!emailValidate(value)) {
                          return 'من فضلك ادخل الاميل صحيح';
                        }
                        return null;
                      }),
                  const Gap(20),
                  TextFormField(
                    textAlign: TextAlign.end,
                    style: TextStyle(color: AppColor.blackcolor),
                    obscureText: isVisable,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '********',
                      hintStyle: getsmallstyle(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable = !isVisable;
                            });
                          },
                          icon: Icon(
                            (isVisable)
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_rounded,
                            color: AppColor.bluecolor,
                          )),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColor.bluecolor,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'من فضلك ادخل كلمه السر';
                      return null;
                    },
                  ),
                  const Gap(5),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    child: Text(
                      'نسيت كلمة السر ؟',
                      style: getsmallstyle(color: AppColor.blackcolor),
                    ),
                  ),
                  const Gap(25),
                  CustomButton(
                      width: double.infinity,
                      height: 50,
                      background: AppColor.bluecolor,
                      radius: 25,
                      text: 'تسجيل دخول',
                      onPressed: () {
                        if (_formkey.currentState!.validate()) 
                        {
                          
                        }
                      }),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Row(
                      children: [
                        Text(
                          'ليس لدي حساب ؟',
                          style: getBodystyle(fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              pushwithReplacement(
                                  context, signup_viwe(index: widget.index));
                            },
                            child: Text(
                              'سجل الان',
                              style: getTitelstyle(fontSize: 14),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
