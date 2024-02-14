abstract class RegisterEvent {}

class RegisterDataEvent extends RegisterEvent{
  final String email;
  final String name;
  final String age;
  final String gender;
  RegisterDataEvent({
    required this.email,
    required this.name,
    required this.age,
    required this.gender});
}
