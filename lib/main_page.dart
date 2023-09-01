import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _vars = 5;
  int _limits = 3;
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
          _buildLimitsInputTable(_limits + 1, _vars + 2),
        ],
      ),
    );
  }

  SingleChildScrollView _buildLimitsInputTable(int rows, int columns) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          defaultColumnWidth: FixedColumnWidth(66),
          children: List.generate(
            rows,
            (row) => (row == 0)
                ? TableRow(
                    children: List.generate(
                        columns,
                        (column) => (column == 0)
                            ? Container()
                            : (column == columns - 1)
                                ? Center(child: Text('b'))
                                : Center(child: Text('a$column'))),
                  )
                : TableRow(
                    children: List.generate(
                        columns,
                        (column) => (column == 0)
                            ? Center(child: Text('f$row(x)'))
                            : _buildInputMatrixItem()),
                  ),
          ),
        ),
      ),
    );
  }

  Padding _buildInputMatrixItem() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(),
      );
}
