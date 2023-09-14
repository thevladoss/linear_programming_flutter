import 'package:flutter/material.dart';
import 'package:linear_flutter/models/step_data.dart';

class StepPage extends StatefulWidget {
  final StepData step;

  StepPage({super.key, required this.step});

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  List<int> _activeElement = [1, 1];

  @override
  void initState() {
    _activeElement =
        (widget.step.element != null) ? widget.step.element! : _activeElement;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Шаг ${widget.step.matrix[0][0].toInt()}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: (widget.step.basis != null) ? 10 : 0,
          ),
          (widget.step.basis != null)
              ? Text(
                  'Базис ${widget.step.basis}',
                )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _buildMatrixTable(context),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildMatrixTable(BuildContext context) {
    List<TableRow> table = [
      TableRow(
        children: List.generate(
          widget.step.matrix.first.length,
          (i) => _buildTableItem(
            (i == 0)
                ? 'x(${widget.step.matrix.first[i].toInt().toString()})'
                : (i == widget.step.matrix.first.length - 1)
                    ? ''
                    : 'x${widget.step.matrix.first[i].toInt().toString()}',
            context,
            weight: FontWeight.bold,
          ),
        ),
      )
    ];

    List<List<int>> possibleElements = widget.step.getPossibleElements();

    table.addAll(
      List.generate(
        widget.step.matrix.length - 2,
        (i) => TableRow(
            children: List.generate(
          widget.step.matrix[i + 1].length,
          (j) => _buildTableItem(
            (j == 0)
                ? 'x${widget.step.matrix[i + 1][j].toInt().toString()}'
                : widget.step.matrix[i + 1][j].toString(),
            context,
            weight: (j == 0) ? FontWeight.bold : FontWeight.normal,
            color: (_activeElement.first == i + 1 && _activeElement.last == j)
                ? Colors.indigo.shade300
                : (possibleElements.contains([i + 1, j]))
                    ? Colors.indigo.shade100
                    : Colors.transparent,
            i: i + 1,
            j: j,
          ),
        )),
      ),
    );

    table.add(
      TableRow(
        children: List.generate(
          widget.step.matrix.last.length,
          (i) => _buildTableItem(
              (i == 0) ? '' : widget.step.matrix.last[i].toString(), context),
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.symmetric(inside: BorderSide()),
          defaultColumnWidth: const FixedColumnWidth(66),
          children: table,
        ),
      ),
    );
  }

  GestureDetector _buildTableItem(String title, BuildContext context,
      {FontWeight weight = FontWeight.w400,
      Color color = Colors.transparent,
      int i = 0,
      int j = 0}) {
    return GestureDetector(
      onTap: () {
        if (i > 0 &&
            i < widget.step.matrix.length - 1 &&
            j > 0 &&
            j < widget.step.matrix[i].length - 1) {
          setState(() {
            _activeElement = [i, j];
          });
        }
      },
      child: ColoredBox(
        color: color,
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: weight),
            ),
          ),
        ),
      ),
    );
  }
}
