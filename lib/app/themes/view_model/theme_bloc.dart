import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<SetThemeEvent>((event, emit) {
      print(
        'ThemeBloc received SetThemeEvent with themeMode: ${event.themeMode}',
      );
      emit(ThemeState(themeMode: event.themeMode));
      print(
        'ThemeBloc emitted new ThemeState with themeMode: ${event.themeMode}',
      );
    });
  }
}
