import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/model/Todo.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on(manejoEventos);
  }

  Future<void> manejoEventos(NavigationEvent event, Emitter<NavigationState> emiter) async {
    if (event is AppStarted || event is NavigateToHome)
    {
      if (kDebugMode) {
        print("Navigate: HomeScreen");
      }
      emiter(HomeScreen());
    }
    if(event is NavigateToForm)
    {
      if (kDebugMode) {
        print("Navigate: NavigateToForm");
      }
      emiter(FormStater());
    }
    if(event is NavigateToDay)
    {
      if (kDebugMode) {
        print("Navigate: NavigateToDay");
      }
      emiter(DayState(event.date));
    }
    if(event is NavigateToFormEdit)
    {
      if (kDebugMode) {
        print("Navigate: NavigateToForm");
      }
      emiter(FormEditStater(event.todo));
    }
  }
}
