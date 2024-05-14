abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoadingState extends UserDetailsState{}

class UserDetailsSuccessState extends UserDetailsState{
  final String name;
  final String? userName;
  final String profilePic;
  final String imageUrl;
  UserDetailsSuccessState({
    required this.name,
    required this.userName,
    required this.profilePic,
    required this.imageUrl,
});
}

class UserDetailsErrorState extends UserDetailsState{}