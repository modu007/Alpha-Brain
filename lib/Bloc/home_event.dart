abstract class HomeEvent {}

class GetPostInitialEvent extends HomeEvent{}

class TabChangeEvent extends HomeEvent{
  final int tabIndex;
  TabChangeEvent({required this.tabIndex});
}
