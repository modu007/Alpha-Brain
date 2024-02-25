abstract class RegisterEvent {}

class RegisterDataEvent extends RegisterEvent{
  final String email;
  final String name;
  final String age;
  final String gender;
  final String username;
  final bool isUsernameValid;
  RegisterDataEvent({
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    required this.username,
    required this.isUsernameValid,
  });
}

class UsernameAvailabilityEvent extends RegisterEvent{
  final String username;
  UsernameAvailabilityEvent({required this.username});
}

class SendOtp extends RegisterEvent{
  final String email;
  SendOtp({required this.email});
}