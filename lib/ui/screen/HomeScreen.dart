import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/bloc/navigator/navigation_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/util/Constants.dart';
import 'package:todo/util/Days.dart';
import 'package:todo/util/Strings.dart';
import 'package:todo/util/TodoColors.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({Key? key}) : super(key: key);

  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {

  final TodoBloc todoBloc = TodoBloc();
  @override
  void initState() {
    todoBloc.add(GetTodos(""));
    super.initState();
  }

  Widget _buildPoke() {
    return BlocProvider(
        create: (_) => todoBloc,
        child: BlocListener<TodoBloc,TodoState>(
          listener: (context,state){
            if(state is TodoDisable)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.text),
                ),
              );
            }
            if(state is TodoDelete)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.text),
                ),
              );
            }
            if(state is TodoActive)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.text),
                ),
              );
            }
          },
          child: BlocBuilder<TodoBloc,TodoState>(builder: (context,state){
            print("HomeScreen: $state");

            if(state is TodoSuccessList)
            {
                var query = state.query;
                print("object");
                var list = state.list;
                query.get().then((value) => print(value.value));
                return HomeWidget(context,query,list);
            }else{
              return const Center(child: CircularProgressIndicator());
            }

          },),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildPoke();
  }

  Widget HomeWidget(context,query,List<DateTime> list)
  {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20,top: 20,bottom: 15),
              alignment: Alignment.centerLeft,
              child: const Text(Strings.TODO_TITLE_MENU,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
          ),
          Expanded(
            flex: orientation == Orientation.landscape ?  8 : 1,
            child: ListView.builder(
              scrollDirection:  orientation == Orientation.landscape ? Axis.vertical : Axis.horizontal,
              itemCount: list.length+1,
              itemBuilder: (context,i)
              {
                if(i < list.length)
                {
                  return itemDaily(list[i]);
                }else {
                  return GestureDetector(
                    onTap: (){
                      _selectDate(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 14,bottom: 14,left: 20,right: 20),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: TodoColors.amarrillo, spreadRadius: 3),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(Strings.TODO_SHOW_MENU,style: TextStyle(),),
                        ],
                      ),
                    ),
                  );
                }

              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20,top: 20,bottom: 15),
              alignment: Alignment.centerLeft,
              child: const Text(Strings.TODO_SUBTITLE_MENU,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
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
          Expanded(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(bottom: 20,top: 20),

                  child: RaisedButton(
                    child: Text(Strings.TODO_BUTTON_MENU, style: TextStyle(fontSize: 15),),
                    onPressed: () => {
                      BlocProvider.of<NavigationBloc>(context).add(
                        NavigateToForm(),
                      )
                    },
                    color: TodoColors.amarrillo,
                    textColor: Colors.black,
                    padding: EdgeInsets.only(left: 30,right: 30),
                    splashColor: Colors.grey,
                  )
              ))
        ],
      ),
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
  
  Widget itemDaily(DateTime d)
  {
    return GestureDetector(
      onTap: (){
        BlocProvider.of<NavigationBloc>(context).add(
          NavigateToDay("${d.day}/${d.month}/${d.year}"),
        );

      },
      child: Container(
        margin: EdgeInsets.only(top: 14,bottom: 14,left: 20,right: 20),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: TodoColors.amarrillo, spreadRadius: 3),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${Days().dayOfWeek(d.weekday)} ${d.day}"),
          ],
        ),
      ),
    );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        BlocProvider.of<NavigationBloc>(context).add(
          NavigateToDay("${picked.day}/${picked.month}/${picked.year}"),
        );
      });
    }
  }

}