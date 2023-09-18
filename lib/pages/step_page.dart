import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_flutter/models/enums.dart';
import 'package:linear_flutter/models/step_data.dart';

import '../bloc/main_bloc.dart';

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
            'Шаг ${step.matrix[0][0]}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            (step.element.first == 0 || step.element.last == 0)
                ? 'Опорный элемент не найден'
                : 'Опорный элемент: ${step.matrix[step.element.first][step.element.last]}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          (step.basis != null)
              ? Text(
                  'Базис: ${step.basis.toString().replaceAll('[', '<').replaceAll(']', '>')}',
                  style: Theme.of(context).textTheme.bodyLarge,
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
          (j) => _buildTableItem(
            (j == 0)
                ? 'x(${step.matrix.first[j].toString()})'
                : (j == step.matrix.first.length - 1)
                    ? ''
                    : 'x${step.matrix.first[j].toString()}',
            context,
            weight: FontWeight.bold,
            i: 0,
            j: j,
          ),
        ),
      )
    ];

    table.addAll(
      List.generate(
        step.matrix.length - 2,
        (i) => TableRow(
            children: List.generate(
          step.matrix[i + 1].length,
          (j) => _buildTableItem(
            (j == 0)
                ? 'x${step.matrix[i + 1][j].toString()}'
                : (context.read<MainBloc>().task.numberType ==
                        NumberType.decimal)
                    ? (step.matrix[i + 1][j]
                                .toDouble()
                                .toString()
                                .split('.')[1]
                                .length >=
                            3)
                        ? step.matrix[i + 1][j].toDouble().toStringAsFixed(3)
                        : step.matrix[i + 1][j].toDouble().toString()
                    : step.matrix[i + 1][j].toString(),
            context,
            weight: (j == 0) ? FontWeight.bold : FontWeight.normal,
            color: (step.element!.first == i + 1 && step.element!.last == j)
                ? Colors.indigo.shade300
                : (j != step.matrix[i + 1].length - 1 &&
                        step.isElementSupport(i + 1, j))
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
          step.matrix.last.length,
          (j) => _buildTableItem(
              (j == 0)
                  ? ''
                  : (context.read<MainBloc>().task.numberType ==
                          NumberType.decimal)
                      ? (step.matrix.last[j]
                                  .toDouble()
                                  .toString()
                                  .split('.')[1]
                                  .length >=
                              3)
                          ? step.matrix.last[j].toDouble().toStringAsFixed(3)
                          : step.matrix.last[j].toDouble().toString()
                      : step.matrix.last[j].toString(),
              context,
              i: step.matrix.length - 1,
              j: j),
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.symmetric(inside: const BorderSide()),
          defaultColumnWidth: const FixedColumnWidth(66),
          children: table,
        ),
      ),
    );
  }

  GestureDetector _buildTableItem(String title, BuildContext context,
      {FontWeight weight = FontWeight.w400,
      Color color = Colors.transparent,
      required int i,
      required int j}) {
    return GestureDetector(
      onTap: () {
        if (color == Colors.indigo.shade100) {
          context.read<MainBloc>().add(MainChangeElementEvent(
              (step.basis != null) ? 2 : 1,
              newElem: [i, j]));
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
