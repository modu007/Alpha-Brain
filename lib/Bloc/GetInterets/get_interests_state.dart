abstract class GetInterestsState {}

class GetInterestsInitial extends GetInterestsState {}

class GetInterestsLoading extends GetInterestsState{}

class GetInterestsSuccess extends GetInterestsState {
  final List<String> listOfInterests;
  final List<String> customTags;
  final List<String> selectedInterests;

  GetInterestsSuccess(
      {required this.listOfInterests,
      required this.customTags,
      required this.selectedInterests});
}

class GetInterestsError extends GetInterestsState{}
