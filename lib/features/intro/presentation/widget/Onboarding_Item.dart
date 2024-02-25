import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/features/intro/data/OnboardingModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class onboardingitem extends StatelessWidget {
  const onboardingitem({
    super.key,
    required this.model,
  });

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(
          flex: 1,
        ),
        SvgPicture.asset(
          model.image,
          width: 300,
        ),
        Text(
          model.titel,
          style: getTitelstyle(),
        ),
        const Gap(20),
        Text(
          model.body,
          style: getBodystyle(),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}