abstract class RegisterState {}

abstract class RegisterScreenActionState extends RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterScreenActionState{}

class RegistrationSuccessFullState extends RegisterState{}

class ErrorState extends RegisterState{}
