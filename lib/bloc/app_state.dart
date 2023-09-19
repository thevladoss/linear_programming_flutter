part of 'app_bloc.dart';

@immutable
sealed class AppState {}

final class AppTaskState extends AppState {}

final class AppBasisState extends AppState {
  final StepData step;

  AppBasisState({required this.step});
}

final class AppSimplexState extends AppState {
  final StepData step;

  AppSimplexState({required this.step});
}

final class AppAnswerState extends AppState {
  final StepData step;

  AppAnswerState({required this.step});
}
