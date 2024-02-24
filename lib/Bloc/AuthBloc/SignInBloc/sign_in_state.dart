abstract class SignInState {}

abstract class SignInActionState extends SignInState{}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState{}

class SignInSuccessState extends SignInActionState{}

class InvalidEmailState extends SignInActionState{}

class SignInErrorState extends SignInActionState{}

