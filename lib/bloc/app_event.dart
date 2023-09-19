part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

final class AppSwitchPageEvent extends AppEvent {
  final int index;
  final StepData? step;

  AppSwitchPageEvent({required this.index, this.step});
}

final class AppCheckTaskEvent extends AppEvent {
  final BuildContext context;

  AppCheckTaskEvent({required this.context});
}

final class AppNextStepEvent extends AppEvent {}

final class AppPrevStepEvent extends AppEvent {}

final class AppChangeElementEvent extends AppEvent {
  final List<int> newElem;
  final int index;

  AppChangeElementEvent(this.index, {required this.newElem});
}

final class AppReloadAppEvent extends AppEvent {
  final BuildContext context;
  final Task? newTask;

  AppReloadAppEvent({required this.context, this.newTask});
}

final class AppShowHelpEvent extends AppEvent {
  final BuildContext context;

  AppShowHelpEvent({required this.context});
}
