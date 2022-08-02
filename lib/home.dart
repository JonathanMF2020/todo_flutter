
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/navigator/navigation_bloc.dart';
import 'package:todo/ui/screen/FormScreen.dart';
import 'package:todo/ui/screen/HomeScreen.dart';
import 'package:todo/util/TodoColors.dart';

import 'ui/screen/DayScreen.dart';
import 'util/Constants.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: TodoColors.amarrillo,
      ),
      title: Constants.NAME_APP,
      home: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (_, state) {
          if (kDebugMode) {
            print("State is : -> $state");
          }
          if (state is HomeScreen || state is NavigationInitial) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: TodoColors.amarrillo,
                  iconTheme: const IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: const Text('Todo'),
                ),
                backgroundColor: TodoColors.fondo,
                body: const HomeScreeen());
          }
          if(state is DayState)
          {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: TodoColors.amarrillo,
                  iconTheme: const IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text(Constants.NAME_APP),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                      NavigateToHome(),
                    ),
                  ),
                ),
                backgroundColor: TodoColors.fondo,
                body: DayScreen(date: state.date),
            );
          }
          if(state is FormEditStater)
          {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: TodoColors.amarrillo,
                  iconTheme: const IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text(Constants.NAME_APP),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                      NavigateToHome(),
                    ),
                  ),
                ),
                backgroundColor: TodoColors.fondo,
                body: FormScreen(edit: true,todo: state.todo,));
          }
          if (state is FormStater) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: TodoColors.amarrillo,
                  iconTheme: const IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text(Constants.NAME_APP),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                      NavigateToHome(),
                    ),
                  ),
                ),
                backgroundColor: TodoColors.fondo,
                body: FormScreen(edit: false,todo: null,));
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
