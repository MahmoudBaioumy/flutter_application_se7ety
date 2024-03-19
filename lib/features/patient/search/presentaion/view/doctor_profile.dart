import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/core/utils/AppColor.dart';
import 'package:flutter_application_se7ety/core/utils/text_styles.dart';
import 'package:flutter_application_se7ety/core/widget/Custom_But.dart';
import 'package:flutter_application_se7ety/core/widget/tile_widget.dart';
import 'package:flutter_application_se7ety/features/auth/Data/doctor_model.dart';
import 'package:flutter_application_se7ety/features/patient/search/presentaion/view/booking_view.dart';
import 'package:flutter_application_se7ety/features/patient/search/presentaion/widgets/contact_icon.dart';
import 'package:gap/gap.dart';

class DoctorProfile extends StatefulWidget {
  final DoctorModel? doctor;

  const DoctorProfile({super.key, required this.doctor});
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'بيانات الدكتور',
          style: getTitelstyle(color: AppColor.white1color),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 25,
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.white1color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ////////////////////// Header -////////////////////////////
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
                          backgroundImage: NetworkImage(widget.doctor!.image)),
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
                        "د. ${widget.doctor!.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTitelstyle(),
                      ),
                      Text(
                        widget.doctor!.specialization,
                        style: getBodystyle(),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Text(
                            widget.doctor!.rating.toString(),
                            style: getBodystyle(),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            Icons.star_rounded,
                            size: 20,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          IconTile(
                            onTap: () {},
                            backColor: AppColor.white2color,
                            imgAssetPath: Icons.phone,
                            num: '1',
                          ),
                          IconTile(
                            onTap: () {},
                            backColor: AppColor.white2color,
                            imgAssetPath: Icons.phone,
                            num: '2',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "نبذه تعريفية",
              style: getBodystyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.doctor!.bio,
              style: getsmallstyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.white2color,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileWidget(
                      text:
                          '${widget.doctor!.openHour} - ${widget.doctor!.closeHour}',
                      icon: Icons.watch_later_outlined),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(
                      text: widget.doctor!.address,
                      icon: Icons.location_on_rounded),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "معلومات الاتصال",
              style: getBodystyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.white2color,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileWidget(text: widget.doctor!.email, icon: Icons.email),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(text: widget.doctor!.phone1, icon: Icons.call),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(text: widget.doctor!.phone2, icon: Icons.call),
                ],
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          background: AppColor.bluecolor,
          text: 'احجز موعد الان',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingView(doctor: widget.doctor!),
              ),
            );
          },
        ),
      ),
    );
  }
}
