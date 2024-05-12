abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoadingState extends OtpState{}

class OtpSuccessState extends OtpState{
  final bool isNewUser;
  OtpSuccessState({
    required this.isNewUser
});
}

class OtpInvalidState extends OtpState{}

class NewUserState extends OtpState{}

class OtpErrorState extends OtpState{}
