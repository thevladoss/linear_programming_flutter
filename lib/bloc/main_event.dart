part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

final class MainSwitchPageEvent extends MainEvent {
  final int index;
  final StepData? step;

  MainSwitchPageEvent({required this.index, this.step});
}

final class MainCheckTaskEvent extends MainEvent {
  final BuildContext context;

  MainCheckTaskEvent({required this.context});
}

final class MainNextStepEvent extends MainEvent {}

final class MainPrevStepEvent extends MainEvent {}

final class MainReloadAppEvent extends MainEvent {
  final BuildContext context;

  MainReloadAppEvent({required this.context});
}

final class MainShowHelpEvent extends MainEvent {
  final BuildContext context;

  MainShowHelpEvent({required this.context});
}
