import 'package:flutter/cupertino.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _vars = 5;
  int _limits = 3;

  @override
  Widget build(BuildContext context) {
    return _buildLimitsInputTable(_limits + 1, _vars + 2);
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
