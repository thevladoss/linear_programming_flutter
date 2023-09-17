part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

final class MainSwitchPageEvent extends MainEvent {
  final int index;

  MainSwitchPageEvent({required this.index});
}

final class MainReloadAppEvent extends MainEvent {
  final BuildContext context;

  MainReloadAppEvent({required this.context});
}

final class MainShowHelpEvent extends MainEvent {
  final BuildContext context;

  MainShowHelpEvent({required this.context});
}
