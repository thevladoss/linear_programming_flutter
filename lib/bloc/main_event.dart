part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

final class MainSwitchPageEvent extends MainEvent {
  final int index;

  MainSwitchPageEvent({required this.index});
}
