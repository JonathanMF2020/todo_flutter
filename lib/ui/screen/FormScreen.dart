import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/navigator/navigation_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/util/Constants.dart';
import 'package:todo/util/Strings.dart';
import 'package:todo/util/TodoColors.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  bool? edit;
  Todo? todo;
  FormScreen({Key? key,this.edit,this.todo}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Personal';
  TextEditingController descripcion = TextEditingController();
  final TodoBloc todoBloc = TodoBloc();
  TextEditingController fecha = TextEditingController();
  var items = [
    'Personal',
    'Educativo',
    'Trabajo'
  ];

  @override
  void initState() {
    print("FormScreen: ${widget.edit}");
    if(widget.todo != null)
    {
      selectedDate = DateFormat('d/M/y').parse(widget.todo!.fecha);
      fecha.text = widget.todo!.fecha;
      descripcion.text = widget.todo!.descripcion;
      dropdownvalue = widget.todo!.tipo;
    }

    super.initState();
  }

  Widget _buildPoke() {
    return FormWidget();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => todoBloc,
        child: BlocListener<TodoBloc,TodoState>(
            listener: (context, state) {
              if (state is TodoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("${state.code} ${state.error}"),
                  ),
                );
              }
              if (state is TodoSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.text),
                  ),
                );
                BlocProvider.of<NavigationBloc>(context).add(
                  NavigateToHome(),
                );
              }
            },
            child: _buildPoke()
        )
    );
  }

  Widget FormWidget()
  {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20,top: 20,bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(widget.edit == false ? Strings.TODO_TITLE_FORM : Strings.TODO_TITLE_FORM_2,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: EdgeInsets.only(left: 20,top: 10,right: 20),
            child:  Column(
              children: [
                Container(
                  child: TextField(
                    controller: fecha,
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),

                      hintText: Strings.TODO_DATE_FORM,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    maxLines: 5,
                    controller: descripcion,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),

                      hintText: Strings.TODO_DESCRIPTION_FORM,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(bottom: 20,top: 20),

                child: RaisedButton(
                  child: Text(Strings.TODO_BUTTON_FORM, style: TextStyle(fontSize: 15),),
                  onPressed: ()async {
                    var t = Todo(fecha.text,descripcion.text,dropdownvalue,Constants.TODO_ACTIVO);

                    if(widget.edit == true)
                    {
                      t.id = widget.todo!.id;
                      todoBloc.add(
                        SaveTodo(t,true),
                      );
                    }else{
                      todoBloc.add(
                        SaveTodo(t,false),
                      );
                    }

                  },
                  color: TodoColors.amarrillo,
                  textColor: Colors.black,
                  padding: EdgeInsets.only(left: 30,right: 30),
                  splashColor: Colors.grey,
                )
            ))


      ],
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fecha.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

}

