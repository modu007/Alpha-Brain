abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoadingState extends OtpState{}

class OtpSuccessState extends OtpState{}

class OtpInvalidState extends OtpState{}

class OtpErrorState extends OtpState{}
