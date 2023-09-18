import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linear_flutter/pages/graph_page.dart';
import 'package:linear_flutter/pages/step_page.dart';
import 'package:linear_flutter/pages/task_page.dart';

import '../bloc/main_bloc.dart';
import 'answer_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is MainTaskState && _selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else if (state is MainBasisState && _selectedIndex != 1) {
            setState(() {
              _selectedIndex = 1;
            });
          } else if (state is MainSimplexState && _selectedIndex != 2) {
            setState(() {
              _selectedIndex = 2;
            });
          } else if (state is MainAnswerState && _selectedIndex != 3) {
            setState(() {
              _selectedIndex = 3;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  groupAlignment: 0,
                  onDestinationSelected: (int index) {
                    if (!context.read<MainBloc>().isAnimation) {
                      setState(() {
                        _selectedIndex = index;
                        context
                            .read<MainBloc>()
                            .add(MainSwitchPageEvent(index: _selectedIndex));
                      });
                    }
                  },
                  labelType: NavigationRailLabelType.selected,
                  leading: _buildActionButton(context),
                  destinations: _buildNavigationDestinations(context),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _buildPage(context, state),
                )
              ],
            ),
            floatingActionButton: _buildMoveButtons(context),
          );
        },
      ),
    );
  }

  Row _buildMoveButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 115,
        ),
        FloatingActionButton.small(
          onPressed: () {
            context.read<MainBloc>().add(MainShowHelpEvent(context: context));
          },
          child: const Icon(
            Icons.question_mark,
            size: 20,
          ),
        ),
        const Spacer(),
        (_selectedIndex != 0)
            ? FloatingActionButton.small(
                onPressed: () {
                  if (!context.read<MainBloc>().isAnimation) {
                    switch (_selectedIndex) {
                      case 1:
                        if (context.read<MainBloc>().currentStep == 0) {
                          context
                              .read<MainBloc>()
                              .add(MainSwitchPageEvent(index: 0));
                        } else {
                          context.read<MainBloc>().add(MainPrevStepEvent());
                        }
                        break;
                      case 2:
                        context.read<MainBloc>().add(MainPrevStepEvent());
                        break;
                      case 3:
                        context.read<MainBloc>().add(MainPrevStepEvent());
                        break;
                    }
                  }
                },
                child: const Icon(Icons.navigate_before),
              )
            : const SizedBox(),
        const SizedBox(
          width: 16,
        ),
        (_selectedIndex != 3)
            ? FloatingActionButton.small(
                onPressed: () {
                  if (!context.read<MainBloc>().isAnimation) {
                    switch (_selectedIndex) {
                      case 0:
                        context
                            .read<MainBloc>()
                            .add(MainCheckTaskEvent(context: context));
                        break;
                      case 1:
                        context.read<MainBloc>().add(MainNextStepEvent());
                        break;
                      case 2:
                        context.read<MainBloc>().add(MainNextStepEvent());
                        break;
                    }
                  }
                },
                child: const Icon(Icons.navigate_next),
              )
            : const SizedBox(
                width: 40,
              ),
      ],
    );
  }

  List<NavigationRailDestination> _buildNavigationDestinations(
      BuildContext context) {
    return <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: FaIcon(FontAwesomeIcons.f),
        label: Text('Задача'),
      ),
      NavigationRailDestination(
        icon: const FaIcon(FontAwesomeIcons.one),
        disabled: (context.read<MainBloc>().task.steps.isEmpty),
        label: const Text('Базис'),
      ),
      NavigationRailDestination(
        icon: const FaIcon(FontAwesomeIcons.two),
        disabled: (context.read<MainBloc>().task.getIndexOfBasis() == 0),
        label: const Text('Симплекс'),
      ),
      NavigationRailDestination(
        icon: const FaIcon(FontAwesomeIcons.three),
        disabled: (context.read<MainBloc>().task.getIndexOfAnswer() == 0),
        label: const Text('Решение'),
      ),
      const NavigationRailDestination(
        disabled: true,
        icon: Icon(
          Icons.show_chart,
          size: 30,
        ),
        label: Text('График'),
      ),
    ];
  }

  Column _buildActionButton(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton.small(
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            context.read<MainBloc>().add(MainReloadAppEvent(context: context));
          },
          child: const FaIcon(Icons.delete_outline),
        ),
        const SizedBox(
          height: 8,
        ),
        FloatingActionButton.small(
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            // TODO add save to file
          },
          child: const Icon(Icons.upload),
        ),
        const SizedBox(
          height: 8,
        ),
        FloatingActionButton.small(
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            // TODO add open from file
          },
          child: const Icon(Icons.download),
        ),
      ],
    );
  }

  Widget _errorPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Базис был задан изначально',
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPage(BuildContext ctx, MainState state) {
    if (state is MainBasisState) {
      return StepPage(
        step: state.step,
      );
    } else if (state is MainSimplexState) {
      return StepPage(step: state.step);
    } else if (state is MainAnswerState) {
      return AnswerPage(step: state.step);
    } else if (state is MainGraphState) {
      return const GraphPage();
    } else {
      return const TaskPage();
    }
  }
}
