import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linear_flutter/pages/step_page.dart';
import 'package:linear_flutter/pages/task_page.dart';

import '../bloc/app_bloc.dart';
import '../models/task.dart';
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
      create: (context) => AppBloc(),
      child: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppTaskState && _selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else if (state is AppBasisState && _selectedIndex != 1) {
            setState(() {
              _selectedIndex = 1;
            });
          } else if (state is AppSimplexState && _selectedIndex != 2) {
            setState(() {
              _selectedIndex = 2;
            });
          } else if (state is AppAnswerState && _selectedIndex != 3) {
            setState(() {
              _selectedIndex = 3;
            });
          }
        },
        builder: (context, state) {
          if (MediaQuery.of(context).size.width <= 500) {
            return _buildMobileView(context, state);
          } else {
            return _buildDesktopView(context, state);
          }
        },
      ),
    );
  }

  Scaffold _buildMobileView(BuildContext context, AppState state) {
    return Scaffold(
      appBar: AppBar(
        actions: _buildMobileActions(context),
      ),
      body: _buildPage(context, state),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (!context.read<AppBloc>().isAnimation) {
            if (index == 1 &&
                (context.read<AppBloc>().task.steps.isEmpty ||
                    context.read<AppBloc>().task.isBasisOnStart())) return;
            if (index == 2 &&
                (context.read<AppBloc>().task.getIndexOfBasis() == 0 &&
                    !context.read<AppBloc>().task.isBasisOnStart())) return;
            if (index == 3 &&
                (context.read<AppBloc>().task.getIndexOfAnswer() == 0 &&
                    context.read<AppBloc>().task.isAnswerExist())) return;

            setState(() {
              _selectedIndex = index;
              context
                  .read<AppBloc>()
                  .add(AppSwitchPageEvent(index: _selectedIndex));
            });
          }
        },
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _buildMobileDestinations(context),
      ),
      floatingActionButton: _buildMoveButtons(context),
    );
  }

  List<Widget> _buildMobileDestinations(BuildContext context) {
    return <Widget>[
      const NavigationDestination(
        icon: FaIcon(FontAwesomeIcons.f),
        label: 'Задача',
      ),
      NavigationDestination(
        icon: FaIcon(
          FontAwesomeIcons.one,
          color: (context.read<AppBloc>().task.steps.isEmpty ||
                  context.read<AppBloc>().task.isBasisOnStart())
              ? Colors.black26
              : Colors.black,
        ),
        label: 'Базис',
      ),
      NavigationDestination(
        icon: FaIcon(
          FontAwesomeIcons.two,
          color: (context.read<AppBloc>().task.getIndexOfBasis() == 0 &&
                  !context.read<AppBloc>().task.isBasisOnStart())
              ? Colors.black26
              : Colors.black,
        ),
        label: 'Симплекс',
      ),
      NavigationDestination(
        icon: FaIcon(
          FontAwesomeIcons.three,
          color: (context.read<AppBloc>().task.getIndexOfAnswer() == 0 &&
                  context.read<AppBloc>().task.isAnswerExist())
              ? Colors.black26
              : Colors.black,
        ),
        label: 'Ответ',
      ),
    ];
  }

  List<Widget> _buildMobileActions(BuildContext context) {
    return [
      IconButton.filledTonal(
        onPressed: () {
          context.read<AppBloc>().add(AppReloadAppEvent(context: context));
        },
        icon: const FaIcon(Icons.delete_outline),
      ),
      // IconButton.filledTonal(
      //   onPressed: () => _onUploadTap(context),
      //   icon: const Icon(Icons.upload),
      // ),
      IconButton.filledTonal(
        onPressed: () => _onDownloadTap(context),
        icon: const Icon(Icons.download),
      ),
      const SizedBox(
        width: 10,
      )
    ];
  }

  Scaffold _buildDesktopView(BuildContext context, AppState state) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: 0,
            onDestinationSelected: (int index) {
              if (!context.read<AppBloc>().isAnimation) {
                setState(() {
                  _selectedIndex = index;
                  context
                      .read<AppBloc>()
                      .add(AppSwitchPageEvent(index: _selectedIndex));
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
  }

  Row _buildMoveButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width <= 500) ? 30 : 115,
        ),
        FloatingActionButton.small(
          onPressed: () {
            context.read<AppBloc>().add(AppShowHelpEvent(context: context));
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
                  if (!context.read<AppBloc>().isAnimation) {
                    switch (_selectedIndex) {
                      case 1:
                        if (context.read<AppBloc>().currentStep == 0) {
                          context
                              .read<AppBloc>()
                              .add(AppSwitchPageEvent(index: 0));
                        } else {
                          context.read<AppBloc>().add(AppPrevStepEvent());
                        }
                        break;
                      case 2:
                        if (context.read<AppBloc>().currentStep == 0) {
                          context
                              .read<AppBloc>()
                              .add(AppSwitchPageEvent(index: 0));
                        } else {
                          context.read<AppBloc>().add(AppPrevStepEvent());
                        }
                        break;
                      case 3:
                        context.read<AppBloc>().add(AppPrevStepEvent());
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
                  if (!context.read<AppBloc>().isAnimation) {
                    switch (_selectedIndex) {
                      case 0:
                        context
                            .read<AppBloc>()
                            .add(AppCheckTaskEvent(context: context));
                        break;
                      case 1:
                        context.read<AppBloc>().add(AppNextStepEvent());
                        break;
                      case 2:
                        context.read<AppBloc>().add(AppNextStepEvent());
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
        disabled: (context.read<AppBloc>().task.steps.isEmpty ||
            context.read<AppBloc>().task.isBasisOnStart()),
        label: const Text('Базис'),
      ),
      NavigationRailDestination(
        icon: const FaIcon(FontAwesomeIcons.two),
        disabled: (context.read<AppBloc>().task.getIndexOfBasis() == 0 &&
            !context.read<AppBloc>().task.isBasisOnStart()),
        label: const Text('Симплекс'),
      ),
      NavigationRailDestination(
        icon: const FaIcon(FontAwesomeIcons.three),
        disabled: (context.read<AppBloc>().task.getIndexOfAnswer() == 0 &&
            context.read<AppBloc>().task.isAnswerExist()),
        label: const Text('Ответ'),
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
            context.read<AppBloc>().add(AppReloadAppEvent(context: context));
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
          onPressed: () => _onUploadTap(context),
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
          onPressed: () => _onDownloadTap(context),
          child: const Icon(Icons.download),
        ),
      ],
    );
  }

  _onDownloadTap(BuildContext context) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'json',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file == null) {
      return;
    }

    file.readAsString().then((value) {
      try {
        Task task = Task.fromJson(value);
        context
            .read<AppBloc>()
            .add(AppReloadAppEvent(context: context, newTask: task));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: (MediaQuery.of(context).size.width <= 500)
                ? null
                : const EdgeInsets.only(right: 60, left: 145, bottom: 15),
            content: const Text('Ошибка! Файл не является решением задачи'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  _onUploadTap(BuildContext context) async {
    var task = context.read<AppBloc>().task;
    if (task.getIndexOfAnswer() != 0) {
      String fileName = 'task_${DateTime.now().millisecondsSinceEpoch}.json';
      final FileSaveLocation? result =
          await getSaveLocation(suggestedName: fileName);
      if (result == null) {
        return;
      }

      final Uint8List fileData = Uint8List.fromList(task.toJson().codeUnits);
      const String mimeType = 'application/json';
      final XFile textFile =
          XFile.fromData(fileData, mimeType: mimeType, name: fileName);
      await textFile.saveTo(result.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: (MediaQuery.of(context).size.width <= 500)
              ? null
              : const EdgeInsets.only(right: 60, left: 145, bottom: 15),
          content: const Text('Задачу необходимо решить до конца'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildPage(BuildContext ctx, AppState state) {
    if (state is AppBasisState) {
      return StepPage(
        step: state.step,
      );
    } else if (state is AppSimplexState) {
      return StepPage(step: state.step);
    } else if (state is AppAnswerState) {
      return AnswerPage(step: state.step);
    } else {
      return const TaskPage();
    }
  }
}
