import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/bloc/navigator/navigation_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/util/Constants.dart';

class DayScreen extends StatefulWidget {
  String? date;
  DayScreen({Key? key,this.date}) : super(key: key);

  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {

  final TodoBloc todoBloc = TodoBloc();
  void initState() {
    todoBloc.add(GetTodos(widget.date!));
    super.initState();
  }

  Widget _buildPoke(Query query) {
    return DayWidget(query);
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => todoBloc,
        child: BlocListener<TodoBloc,TodoState>(
            listener: (context, state) {

            },
            child: BlocBuilder<TodoBloc,TodoState>(
                builder: (context, state) {
                  if(state is TodoSuccessDay)
                  {
                    return _buildPoke(state.query);
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }

                },
            )
        )
    );
  }

  Widget DayWidget(Query query)
  {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20,top: 20,bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(widget.date!,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
        ),
        Expanded(
          flex: 5,
          child: FirebaseAnimatedList(

            query: query,
            itemBuilder: (context, snapshot, animation, index) {
              Todo todo = Todo("","","",Constants.TODO_INACTIVO);
              final json = snapshot.value as Map<dynamic, dynamic>;
              todo = Todo.fromJson(json);
              todo.id = snapshot.key;
              return itemTask(todo);
            },
          ),
        ),


      ],
    );
  }

  Widget itemTask(Todo todo)
  {
    return Slidable(
      key: Key(todo.id.toString()),
      endActionPane: arr(todo),
      startActionPane: arr(todo),
      child: Card(

        color: Colors.white,
        margin: EdgeInsets.only(top: 14,bottom: 14,left: 20,right: 20),
        child: Container(
          padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            color: todo.activo == 1 ? getColor(todo.tipo) : Colors.grey,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(todo.fecha,style: TextStyle(fontSize: 10,color: Colors.grey,decoration: todo.activo == 1? null : TextDecoration.lineThrough,)),
                          )
                        ],
                      )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10,left: 25,right: 25),
                alignment: Alignment.centerLeft,
                child: Text(todo.descripcion,textAlign: TextAlign.left,style: TextStyle(decoration: todo.activo == 1? null : TextDecoration.lineThrough,)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String tipo)
  {
    Color color;
    switch(tipo)
    {
      case "Personal":{
        color = Colors.green;
      }
      break;
      case "Educativo":{
        color = Colors.brown;
      }
      break;
      case "Trabajo":{
        color = Colors.blue;
      }
      break;
      default: {
        color = Colors.white;
      }
      break;
    }
    return color;
  }

  ActionPane arr(Todo todo){
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context){
            if(todo.activo == 0)
            {
              todoBloc.add(DeleteTodo(todo));
            }else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error"),
                ),
              );
            }
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Eliminar',
        ),
        SlidableAction(
          onPressed: (context){
            if(todo.activo == 1)
            {
              BlocProvider.of<NavigationBloc>(context).add(
                NavigateToFormEdit(todo),
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error"),
                ),
              );
            }

          },
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Editar',
        ),
        SlidableAction(
          onPressed: (context){
            if(todo.activo == 1)
            {
              todoBloc.add(DisableTodo(todo));
            }else {
              todoBloc.add(ActiveTodo(todo));
            }
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.check,
          label: 'Listo',
        ),
      ],
    );
  }


}

