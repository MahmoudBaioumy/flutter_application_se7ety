class AuthStates {}

class AuthinitStates extends AuthStates {}

//login
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
 
}

class LoginErorrStates extends AuthStates {
  final String Erorr;

  LoginErorrStates({required this.Erorr});
}


//signup as paiant
class signupLoadingStates extends AuthStates {}

class signupSuccessStates extends AuthStates {}

class signupErorrStates extends AuthStates {
  final String Erorr;

  signupErorrStates({required this.Erorr});
}

//upload Data  of doctor
class UploaddataLoadingStates extends AuthStates {}

class UploaddataSuccessStates extends AuthStates {}

class UploaddataErorrStates extends AuthStates {
  final String Erorr;

  UploaddataErorrStates({required this.Erorr});
}
