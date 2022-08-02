part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class GetTodos extends TodoEvent {
  final String date;

  const GetTodos(this.date);
}

class SaveTodo extends TodoEvent {
  final Todo todo;
  final bool edit;

  const SaveTodo(this.todo,this.edit);
}

class DisableTodo extends TodoEvent{
  final Todo todo;

  const DisableTodo(this.todo);
}

class ActiveTodo extends TodoEvent{
  final Todo todo;

  const ActiveTodo(this.todo);
}

class DeleteTodo extends TodoEvent{
  final Todo todo;

  const DeleteTodo(this.todo);
}

class GetTodosFilter extends TodoEvent {
  final String date;

  const GetTodosFilter(this.date);
}
