import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/function/routing.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';
import 'package:flutter_application_se7ety/features/intro/data/OnboardingModel.dart';
import 'package:flutter_application_se7ety/features/intro/presentation/view/welcome_view.dart';
import 'package:flutter_application_se7ety/features/intro/presentation/widget/Onboarding_Item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  //list of page who want to routaing of it
  List<OnboardingModel> Screens = [
    OnboardingModel(
      image: 'assets/on1.svg',
      titel: 'ابحث عن دكتورك المتخصص',
      body:
          'اكتشف مجموعة واسعة من الأطباء الخبراء والمتخصصين في مختلف المجالات',
    ),
    OnboardingModel(
        image: 'assets/on2.svg',
        titel: 'ابحث عن دكتورك المتخصص',
        body: ' احجز المواعيد بضغطة زرار في أي وقت وفي أي مكان.'),
    OnboardingModel(
      image: 'assets/on3.svg',
      titel: 'ابحث عن دكتورك المتخصص',
      body: 'كن مطمئنًا لأن خصوصيتك وأمانك هما أهم أولوياتنا.',
    )
  ];

  @override
  var pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white1color,
        actions: [
          TextButton(
              onPressed: () {
                pushwithReplacement(context, const welcome_page());
              },
              child: Text(
                'تخطي',
                style: getTitelstyle(fontSize: 16, color: AppColor.bluecolor),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                //to take the index of page to use it
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: pageController,
                itemCount: Screens.length,
                itemBuilder: (context, index) {
                  return onboardingitem(model: Screens[index]);
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: AppColor.bluecolor,
                      dotHeight: 10,
                    ),
                  ),
                  const Spacer(),

                  // to Show this buttom in the last page of onboarding
                  (index == Screens.length - 1)
                      ? CustomButton(
                          text: ('هيا بنا'),
                          onPressed: () {
                            pushwithReplacement(context, const welcome_page());
                          },
                          background: AppColor.bluecolor,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
