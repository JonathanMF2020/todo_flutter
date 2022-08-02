part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState{
  final String text;
  const TodoSuccess(this.text);
}

class TodoDisable extends TodoState{
  final String text;
  const TodoDisable(this.text);
}

class TodoActive extends TodoState{
  final String text;
  const TodoActive(this.text);
}

class TodoDelete extends TodoState{
  final String text;
  const TodoDelete(this.text);
}

class TodoSuccessList extends TodoState{
  final Query query;
  final List<DateTime> list;
  const TodoSuccessList(this.query,this.list);
}

class TodoSuccessDay extends TodoState{
  final Query query;
  const TodoSuccessDay(this.query);
}


class TodoError extends TodoState {
  final String error;
  final int code;
  const TodoError(this.code,this.error);
}