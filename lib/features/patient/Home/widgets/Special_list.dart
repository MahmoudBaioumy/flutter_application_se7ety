import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/features/patient/Home/data/card_model.dart';
import 'package:flutter_application_se7ety/features/patient/Home/presentaion/explore_spqclist.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class SpecialistsBanner extends StatelessWidget {
  const SpecialistsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("التخصصات", style: getTitelstyle(fontSize: 16)),
        SizedBox(
          height: 230,
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExploreList(
                              specialization: cards[index].doctor,
                            )),
                  );
                },
                child: ItemCardWidget(
                    title: cards[index].doctor,
                    color: cards[index].cardBackground,
                    lightColor: cards[index].cardlightColor),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.lightColor});
  final String title;
  final Color color;
  final Color lightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150,
      margin: const EdgeInsets.only(left: 15, bottom: 15, top: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: lightColor.withOpacity(.8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(
                backgroundColor: lightColor,
                radius: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/doctor-card.svg',
                    width: 150,
                  ),
                  const Gap(10),
                  Text(title,
                      textAlign: TextAlign.center,
                      style:
                          getTitelstyle(color: AppColor.white1color, fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}