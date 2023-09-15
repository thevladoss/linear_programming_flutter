part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainTaskState extends MainState {}

final class MainBasisState extends MainState {}

final class MainSimplexState extends MainState {}

final class MainAnswerState extends MainState {}

final class MainGraphState extends MainState {}
