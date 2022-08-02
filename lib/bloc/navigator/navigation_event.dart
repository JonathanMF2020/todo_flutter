part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends NavigationEvent {}

class NavigateToHome extends NavigationEvent {}
class NavigateToForm extends NavigationEvent {}
class NavigateToDay extends NavigationEvent {
  final String date;
  const NavigateToDay(this.date);
}
class NavigateToFormEdit extends NavigationEvent {
  final Todo todo;

  const NavigateToFormEdit(this.todo);
}