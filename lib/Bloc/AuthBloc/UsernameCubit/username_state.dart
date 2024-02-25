abstract class UsernameState {}

class UsernameInitial extends UsernameState {}

class UsernameSuccessState extends UsernameState {
  final bool isUsernameValid;
  UsernameSuccessState({required this.isUsernameValid});
}

class UsernameExistsState extends UsernameState {
  final bool isUsernameValid;
  UsernameExistsState({required this.isUsernameValid});
}

class UsernameErrorState extends UsernameState {}
