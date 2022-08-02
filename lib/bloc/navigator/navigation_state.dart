part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class HomeScreen extends NavigationState {}
class FormStater extends NavigationState {}
class DayState extends NavigationState {
  final String date;
  const DayState(this.date);
}
class FormEditStater extends NavigationState {
  final Todo todo;
  const FormEditStater(this.todo);
}