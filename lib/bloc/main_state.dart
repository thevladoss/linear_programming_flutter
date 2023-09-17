part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainTaskState extends MainState {}

final class MainBasisState extends MainState {
  final StepData step;

  MainBasisState({required this.step});
}

final class MainSimplexState extends MainState {
  final StepData step;

  MainSimplexState({required this.step});
}

final class MainAnswerState extends MainState {
  final StepData step;

  MainAnswerState({required this.step});
}

final class MainGraphState extends MainState {}
