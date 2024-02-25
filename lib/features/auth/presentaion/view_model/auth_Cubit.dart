import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_se7ety/features/auth/presentaion/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCuibt extends Cubit<AuthStates> {
  AuthCuibt() : super(AuthinitStates());

  //login

  //register as doctor

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
        'name':name,
        'email':user?.email,
        'iamge':'',   
        'bio':'',
        'city':'',
        'phone':'',
        'age':'',
        });

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
}
