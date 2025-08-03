import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  SetThemeEvent({required this.themeMode});
}
