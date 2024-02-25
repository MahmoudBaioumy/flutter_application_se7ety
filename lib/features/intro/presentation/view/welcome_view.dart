import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view/login_view.dart';
import 'package:gap/gap.dart';

class welcome_page extends StatefulWidget {
  const welcome_page({super.key});

  @override
  State<welcome_page> createState() => _welcome_oageState();
}

class _welcome_oageState extends State<welcome_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Opacity(
        opacity: .7,
        child: Stack(
          children: [
            Image.asset(
              'assets/welcome.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
                top: 100,
                right: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اهلا بيك',
                      style: getTitelstyle(fontSize: 50),
                    ),
                    const Gap(10),
                    Text(
                      'سجل واحجز عند دكتورك وانت فالبيت',
                      style: getBodystyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Positioned(
                bottom: 80,
                left: 25,
                right: 25,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: AppColor.bluecolor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.greycolor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        )
                      ]),
                  child: Column(
                    children: [
                      Text(
                        'سجل دلوقتي ك',
                        style: getBodystyle(
                            fontSize: 18, color: AppColor.white1color),
                      ),
                      const Gap(40),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              push(context, const login_view(index: 0));
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColor.white2color.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'دكتور',
                                  style:
                                      getTitelstyle(color: AppColor.blackcolor),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          GestureDetector(
                            onTap: () {
                              push(context, const login_view(index: 1));
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColor.white2color.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'مريض',
                                  style:
                                      getTitelstyle(color: AppColor.blackcolor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
