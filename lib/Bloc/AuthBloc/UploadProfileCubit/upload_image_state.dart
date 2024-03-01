abstract class UploadImageState {}

abstract class UploadImageActionState extends UploadImageState{}

class UploadImageInitial extends UploadImageState {}

class UploadProfileLoadingState extends UploadImageState {}

class UploadProfileSuccessState extends UploadImageState {
  final String? path;
  UploadProfileSuccessState({required this.path});
}

class CouldNotUploadImageState extends UploadImageActionState{
}

class UploadProfileErrorState extends UploadImageState {}