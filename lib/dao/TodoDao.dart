import 'package:firebase_database/firebase_database.dart';
import 'package:todo/model/Todo.dart';

class TodoDao{
  final DatabaseReference _todoDao =
  FirebaseDatabase.instance.ref().child('todos');

  void saveTodo(Todo todo) {
    _todoDao.push().set(todo.toJson());
  }

  Query getTodos() {
    return _todoDao;
  }

  Query getTodosDate(String date) {
    return _todoDao.orderByChild("fecha").equalTo(date);
  }

  String disable(Todo todo)
  {
    _todoDao.child(todo.id!).update({
      "activo": 0
    }).then((_) {
      return "Disable Succesfully";
    }).catchError((onError) {
      return "Error";
    });
    return "";
  }

  String delete(Todo todo)
  {
    _todoDao.child(todo.id!).remove();
    return "Delete Succesfully";
  }

  String active(Todo todo)
  {
    _todoDao.child(todo.id!).update({
      "activo": 1
    }).then((_) {
      return "Disable Succesfully";
    }).catchError((onError) {
      return "Error";
    });
    return "";
  }

  String update(Todo todo) {
    _todoDao.child(todo.id!).update({
      "descripcion": todo.descripcion,
      "fecha": todo.fecha,
      "tipo": todo.tipo,
    }).then((_) {
      return "Update Succesfully";
    }).catchError((onError) {
      return "Error";
    });
    return "";
  }

}