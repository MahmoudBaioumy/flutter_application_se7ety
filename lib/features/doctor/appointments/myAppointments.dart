import 'package:flutter/material.dart';
import 'package:flutter_application_se7ety/features/doctor/appointments/myAppointmentList.dart';

class DoctorAppointments extends StatefulWidget {
  const DoctorAppointments({super.key});

  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<DoctorAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'مواعيد الحجز',
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: DoctorAppointmentList(),
      ),
    );
  }
}