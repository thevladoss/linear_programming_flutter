import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fraction/fraction.dart';
import 'package:linear_flutter/pages/step_page.dart';
import 'package:linear_flutter/pages/graph_page.dart';
import 'package:linear_flutter/pages/task_page.dart';

import '../main.dart';
import '../models/enums.dart';
import '../models/step_data.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<StepData> steps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: 0,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            leading: _buildActionButton(),
            destinations: _buildNavigationDestinations,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildPageFromIndex(),
          )
        ],
      ),
      floatingActionButton: _buildMoveButtons(),
    );
  }

  Row _buildMoveButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        (_selectedIndex != 0)
            ? FloatingActionButton.small(
                onPressed: () {
                  switch (_selectedIndex) {
                    case 3:
                      setState(() {
                        _selectedIndex = 2;
                      });
                      break;
                    default:
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
                  switch (_selectedIndex) {
                    case 0:
                      setState(() {
                        _selectedIndex = 1;
                      });
                      break;
                    default:
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

  List<NavigationRailDestination> get _buildNavigationDestinations {
    return const <NavigationRailDestination>[
      NavigationRailDestination(
        icon: FaIcon(FontAwesomeIcons.f),
        label: Text('Задача'),
      ),
      NavigationRailDestination(
        icon: FaIcon(FontAwesomeIcons.one),
        label: Text('Базис'),
      ),
      NavigationRailDestination(
        icon: FaIcon(FontAwesomeIcons.two),
        label: Text('Симплекс'),
      ),
      NavigationRailDestination(
        disabled: true,
        icon: Icon(
          Icons.show_chart,
          size: 30,
        ),
        label: Text('График'),
      ),
    ];
  }

  Column _buildActionButton() {
    return Column(
      children: [
        FloatingActionButton.small(
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            // Add your onPressed code here!
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
            // Add your onPressed code here!
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
            // Add your onPressed code here!
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

  Widget _buildPageFromIndex() {
    switch (_selectedIndex) {
      case 1:
        return StepPage(
          step: step(StepData(func: {
            1: -5,
            2: -4,
            3: -3,
            4: -2,
            5: 3
          }, matrix: [
            [
              0.toFraction(),
              1.toFraction(),
              2.toFraction(),
              3.toFraction(),
              4.toFraction(),
              5.toFraction(),
              0.toFraction()
            ],
            [
              6.toFraction(),
              2.toFraction(),
              1.toFraction(),
              1.toFraction(),
              1.toFraction(),
              (-1).toFraction(),
              3.toFraction()
            ],
            [
              7.toFraction(),
              1.toFraction(),
              (-1).toFraction(),
              0.toFraction(),
              1.toFraction(),
              1.toFraction(),
              1.toFraction()
            ],
            [
              8.toFraction(),
              (-2).toFraction(),
              (-1).toFraction(),
              (-1).toFraction(),
              1.toFraction(),
              0.toFraction(),
              1.toFraction()
            ],
          ], varsCount: 5, type: NumberType.fraction)),
        );
      case 2:
        return StepPage(
          step: step(StepData(func: {
            1: -5,
            2: -4,
            3: -3,
            4: -2,
            5: 3
          }, matrix: [
            [
              0.toFraction(),
              1.toFraction(),
              2.toFraction(),
              3.toFraction(),
              4.toFraction(),
              5.toFraction(),
              0.toFraction()
            ],
            [
              6.toFraction(),
              2.toFraction(),
              1.toFraction(),
              1.toFraction(),
              1.toFraction(),
              (-1).toFraction(),
              3.toFraction()
            ],
            [
              7.toFraction(),
              1.toFraction(),
              (-1).toFraction(),
              0.toFraction(),
              1.toFraction(),
              1.toFraction(),
              1.toFraction()
            ],
            [
              8.toFraction(),
              (-2).toFraction(),
              (-1).toFraction(),
              (-1).toFraction(),
              1.toFraction(),
              0.toFraction(),
              1.toFraction()
            ],
          ], varsCount: 5, type: NumberType.fraction)),
        );
      case 3:
        return GraphPage();
      default:
        return TaskPage();
    }
  }
}
