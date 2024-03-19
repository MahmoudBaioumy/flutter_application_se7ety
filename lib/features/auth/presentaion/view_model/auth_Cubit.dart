import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_se7ety/features/auth/Data/doctor_model.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCuibt extends Cubit<AuthStates> {
  AuthCuibt() : super(AuthinitStates());

  //login

  login(String email, String password) {
    emit(LoginLoadingStates());
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(LoginSuccessStates());
      });
    } catch (e) {
      emit(LoginErorrStates(Erorr: 'حدثت مشكله في التسجيل'));
    }
  }

  //register as paitenet

  registerpatient(String name, String email, String password) async {
    emit(signupLoadingStates());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      //User form Auth w Firestore

      User? user = credential.user;
      await user?.updateDisplayName(name);

      FirebaseFirestore.instance.collection('patient').doc(user?.uid).set({
        'name': name,
        'email': user?.email,
        'iamge': '',
        'bio': '',
        'city': '',
        'phone': '',
        'age': '',
      }, SetOptions(merge: true));

      emit(signupSuccessStates());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(signupErorrStates(Erorr: 'كلمه المرور ضعيفه'));
      } else if (e.code == 'email-already-in-use') {
        emit(signupErorrStates(Erorr: 'الحساب موجود بالفعل'));
      } else {
        emit(signupErorrStates(Erorr: 'حدثت مشكله في التسجيل'));
        print(e);
      }
    }
  }
  //register as doctor

  registerDoctor(String name, String email, String password) async {
    emit(signupLoadingStates());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user!;
      user.updateDisplayName(name);

      // firestore
      FirebaseFirestore.instance.collection('doctor').doc(user.uid).set({
        'name': name,
        'image': null,
        'specialization': null,
        'rating': null,
        'email': user.email,
        'phone1': null,
        'phone2': null,
        'bio': null,
        'openHour': null,
        'closeHour': null,
        'address': null,
      }, SetOptions(merge: true));
      emit(signupSuccessStates());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(signupErorrStates(Erorr: 'كلمة السر ضعيفه'));
      } else if (e.code == 'email-already-in-use') {
        emit(signupErorrStates(Erorr: 'الحساب موجود بالفعل'));
      }
    } catch (e) {
      emit(signupErorrStates(Erorr: 'حدثت مشكله فالتسجيل حاول لاحقا'));
    }
  }

  // upload data from dctor
  uploadDoctorData(DoctorModel doctor) {
    emit(UploaddataLoadingStates());

    try {
      FirebaseFirestore.instance.collection('doctor').doc(doctor.id).set({
        'image': doctor.image,
        'specialization': doctor.specialization,
        'rating': doctor.rating,
        'phone1': doctor.phone1,
        'phone2': doctor.phone2,
        'bio': doctor.bio,
        'openHour': doctor.openHour,
        'closeHour': doctor.closeHour,
        'address': doctor.address,
      }, SetOptions(merge: true));

      emit(UploaddataSuccessStates());
    } catch (e) {
      emit(UploaddataErorrStates(Erorr: 'حدثت مشكله حاول لاحقا'));
    }
  }
}
