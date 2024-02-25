class AuthStates {}

class AuthinitStates extends AuthStates {}

//login
class LoginLoadingStates extends AuthStates {}

class LoginSuccessStates extends AuthStates {}

class LoginErorrStates extends AuthStates {
  final String Erorr;

  LoginErorrStates({required this.Erorr});
}

//signup
class signupLoadingStates extends AuthStates {}

class signupSuccessStates extends AuthStates {}

class signupErorrStates extends AuthStates {
  final String Erorr;

  signupErorrStates({required this.Erorr});
}
