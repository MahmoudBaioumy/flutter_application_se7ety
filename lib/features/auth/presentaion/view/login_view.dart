import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/email_vaildate.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_dialogs.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view/signup_view.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_Cubit.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_states.dart';
import 'package:flutter_application_se7ety/features/doctor/nav_bar.dart';
import 'package:flutter_application_se7ety/features/patient/Home/presentaion/nav_par.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.index});
  final int index;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisable = true;

  String handleUserType() {
    return widget.index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCuibt, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          (widget.index == 0)
              ? pushAndRemoveUntil(context, const DoctorNavBar())
              : pushAndRemoveUntil(context, const PatientMainPage());
        } else if (state is LoginErorrStates) {
          Navigator.pop(context);
          showErrorDialog(context, state.Erorr);
        } else {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سجل دخول الان كـ "${handleUserType()}"',
                      style: getTitelstyle(),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: 'mahmoudbaioumy@gmail.com',
                        hintStyle: getBodystyle(color: AppColor.greycolor),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: AppColor.bluecolor,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل الايميل';
                        } else if (!emailValidate(value)) {
                          return 'من فضلك ادخل الايميل صحيحا';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.end,
                      style: TextStyle(color: AppColor.blackcolor),
                      obscureText: isVisable,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: '********',
                        hintStyle: getBodystyle(color: AppColor.greycolor),
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
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(top: 5, right: 10),
                      child: Text(
                        'نسيت كلمة السر ؟',
                        style: getsmallstyle(),
                      ),
                    ),
                    const Gap(20),
                    CustomButton(
                      width: 500,
                      background: AppColor.bluecolor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<AuthCuibt>().login(
                              _emailController.text, _passwordController.text);
                        }
                      },
                      text: "تسجيل الدخول",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لدي حساب ؟',
                            style: getBodystyle(color: AppColor.blackcolor),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      signup_viwe(index: widget.index),
                                ));
                              },
                              child: Text(
                                'سجل الان',
                                style: getBodystyle(color: AppColor.bluecolor),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
