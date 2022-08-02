import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/dao/TodoDao.dart';
import 'package:todo/model/Todo.dart';


part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on(manejoEventos);
  }

  Future<void> manejoEventos(TodoEvent event, Emitter<TodoState> emit) async {
    try {
      TodoDao todoDao = TodoDao();
      TodoLoading();
      if (event is SaveTodo) {
        if(event.edit == false)
        {
          if(event.todo.fecha.isNotEmpty && event.todo.descripcion.isNotEmpty && event.todo.tipo.isNotEmpty )
          {
            todoDao.saveTodo(event.todo);
            emit(const TodoSuccess("The task is succesfully"));
            emit(TodoLoading());
          }else{
            emit(const TodoError(101,"Some field is not complete"));
            emit(TodoLoading());
          }
        }else{
          if(event.todo.fecha.isNotEmpty && event.todo.descripcion.isNotEmpty && event.todo.tipo.isNotEmpty )
          {
            todoDao.update(event.todo);
            emit(const TodoSuccess("The task is succesfully"));
            emit(TodoLoading());
          }else{
            emit(const TodoError(101,"Some field is not complete"));
            emit(TodoLoading());
          }
        }
      }
      if(event is DisableTodo)
      {
        todoDao.disable(event.todo);
        emit(const TodoDisable("The task is succesfully"));
        var now = DateTime.now();
        List<DateTime> list = List.generate(7, (i) => now.add(Duration(days: i)));
        emit(TodoSuccessList(todoDao.getTodos(),list));
      }
      if(event is ActiveTodo)
      {
        todoDao.active(event.todo);
        emit(const TodoActive("The task is succesfully"));
        var now = DateTime.now();
        List<DateTime> list = List.generate(7, (i) => now.add(Duration(days: i)));
        emit(TodoSuccessList(todoDao.getTodos(),list));
      }
      if(event is DeleteTodo)
      {
        todoDao.delete(event.todo);
        emit(const TodoDelete("The task is succesfully"));
        var now = DateTime.now();
        List<DateTime> list = List.generate(7, (i) => now.add(Duration(days: i)));
        emit(TodoSuccessList(todoDao.getTodos(),list));
      }
      if (event is GetTodos) {
        if(event.date == "")
        {
          emit(TodoLoading());
          var now = DateTime.now();
          List<DateTime> list = List.generate(7, (i) => now.add(Duration(days: i)));
          emit(TodoSuccessList(todoDao.getTodos(),list));
        }else{
          emit(TodoLoading());
          emit(TodoSuccessDay(todoDao.getTodosDate(event.date)));
        }


      }
    } on Exception {
      emit(const TodoError(100,"Failed in Todo Task"));
      emit(TodoLoading());
    }
  }
}