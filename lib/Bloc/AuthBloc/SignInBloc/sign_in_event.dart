abstract class SignInEvent {}

class LoginEvent extends SignInEvent{
  final String email;
  final bool isValidEmail;
  LoginEvent({
    required this.email,
    required this.isValidEmail,
  });
}
