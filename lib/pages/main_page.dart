import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linear_flutter/pages/basis_page.dart';
import 'package:linear_flutter/pages/graph_page.dart';
import 'package:linear_flutter/pages/simplex_page.dart';
import 'package:linear_flutter/pages/task_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

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
            leading: Column(
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
                SizedBox(
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
                SizedBox(
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
            ),
            destinations: const <NavigationRailDestination>[
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
                icon: Icon(
                  Icons.show_chart,
                  size: 30,
                ),
                disabled: true,
                label: Text('График'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          _buildPageFromIndex()
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.navigate_before),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton.small(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }

  Widget _buildPageFromIndex() {
    switch (_selectedIndex) {
      case 1:
        return BasisPage();
      case 2:
        return SimplexPage();
      case 3:
        return GraphPage();
      default:
        return TaskPage();
    }
  }
}
