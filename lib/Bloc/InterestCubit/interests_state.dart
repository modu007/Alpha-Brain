abstract class InterestsState {}

abstract class InterestActionState extends InterestsState{}

class InterestsInitial extends InterestsState {}

class InterestsLoading extends InterestsState {}

class InterestsSaved extends InterestActionState {}

class AtLeastTwoInterests extends InterestActionState {}

class InterestError extends InterestActionState{}
