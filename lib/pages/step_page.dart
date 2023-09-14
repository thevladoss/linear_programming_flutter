import 'package:flutter/material.dart';
import 'package:linear_flutter/models/step_data.dart';

class StepPage extends StatelessWidget {
  final StepData step;

  const StepPage({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Шаг ${step.matrix[0][0].toInt()}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: (step.basis != null) ? 10 : 0,
          ),
          (step.basis != null)
              ? Text(
                  'Базис ${step.basis}',
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
          step.matrix.first.length,
          (i) => _buildTableItem(
            (i == 0)
                ? 'x(${step.matrix.first[i].toInt().toString()})'
                : (i == step.matrix.first.length - 1)
                    ? ''
                    : 'x${step.matrix.first[i].toInt().toString()}',
            context,
            weight: FontWeight.bold,
          ),
        ),
      )
    ];

    List<List<int>> possibleElements = step.getPossibleElements();

    table.addAll(
      List.generate(
        step.matrix.length - 2,
        (i) => TableRow(
            children: List.generate(
          step.matrix[i + 1].length,
          (j) => _buildTableItem(
            (j == 0)
                ? 'x${step.matrix[i + 1][j].toInt().toString()}'
                : step.matrix[i + 1][j].toString(),
            context,
            weight: (j == 0) ? FontWeight.bold : FontWeight.normal,
            color: (step.element != null &&
                    step.element!.first == i + 1 &&
                    step.element!.last == j)
                ? Colors.indigo.shade300
                : (possibleElements.contains([i + 1, j]))
                    ? Colors.indigo.shade100
                    : Colors.transparent,
          ),
        )),
      ),
    );

    table.add(
      TableRow(
        children: List.generate(
          step.matrix.last.length,
          (i) => _buildTableItem(
            (i == 0) ? '' : step.matrix.last[i].toString(),
            context,
          ),
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

  ColoredBox _buildTableItem(String title, BuildContext context,
      {FontWeight weight = FontWeight.w400, Color color = Colors.transparent}) {
    return ColoredBox(
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
    );
  }
}
