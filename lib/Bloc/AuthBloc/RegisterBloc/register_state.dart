abstract class RegisterState {}

abstract class RegisterScreenActionState extends RegisterState {}

class RegisterInitial extends RegisterState {
  final bool isUsernameValid;
  RegisterInitial({required this.isUsernameValid});
}

class RegisterLoadingState extends RegisterScreenActionState{}

class RegistrationSuccessFullState extends RegisterState{
  final String email;
  RegistrationSuccessFullState({required this.email});
}


class OtpSendState extends RegisterState{
  final String email;
  OtpSendState({required this.email});
}

class UsernameInvalidState extends RegisterScreenActionState{}

class EmailInvalidState extends RegisterScreenActionState{}

class FullNameInvalidState extends RegisterScreenActionState{}

class DobInvalidState extends RegisterScreenActionState{}

class ErrorState extends RegisterState{}

class SelectLanguage extends RegisterScreenActionState{}
