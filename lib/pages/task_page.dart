import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linear_flutter/models/enums.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            NumberStepper(
              initialValue: _vars,
              minValue: 1,
              maxValue: 16,
              step: 1,
              onChanged: (value) {
                setState(() {
                  _vars = value;
                });
              },
            ),
            NumberStepper(
              initialValue: _limits,
              minValue: 1,
              maxValue: 16,
              step: 1,
              onChanged: (value) {
                setState(() {
                  _limits = value;
                });
              },
            ),
            NumberTypeChoice(),
            FuncTypeChoice()
          ],
        ),
        Column(
          children: [
            _buildLimitsInputTable(_limits + 1, _vars + 2),
          ],
        ),
      ],
    );
  }

  SingleChildScrollView _buildLimitsInputTable(int rows, int columns) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          defaultColumnWidth: const FixedColumnWidth(66),
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

class NumberStepper extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;
  final Function(int) onChanged;

  const NumberStepper({
    super.key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.onChanged,
  });

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_currentValue > widget.minValue) {
                _currentValue -= widget.step;
              }
            });

            widget.onChanged(_currentValue);
          },
        ),
        Text(
          _currentValue.toString(),
          style: const TextStyle(fontSize: 30),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (_currentValue < widget.maxValue) {
                _currentValue += widget.step;
              }

              widget.onChanged(_currentValue);
            });
          },
        ),
      ],
    );
  }
}

class NumberTypeChoice extends StatefulWidget {
  const NumberTypeChoice({super.key});

  @override
  State<NumberTypeChoice> createState() => _NumberTypeChoiceState();
}

class _NumberTypeChoiceState extends State<NumberTypeChoice> {
  NumberType numberType = NumberType.decimal;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<NumberType>(
      segments: const <ButtonSegment<NumberType>>[
        ButtonSegment<NumberType>(
          value: NumberType.decimal,
          label: Text('Десятичные'),
        ),
        ButtonSegment<NumberType>(
          value: NumberType.fraction,
          label: Text('Обыкновенные'),
        ),
      ],
      showSelectedIcon: false,
      selected: <NumberType>{numberType},
      onSelectionChanged: (Set<NumberType> newSelection) {
        setState(() {
          numberType = newSelection.first;
        });
      },
    );
  }
}

class FuncTypeChoice extends StatefulWidget {
  const FuncTypeChoice({super.key});

  @override
  State<FuncTypeChoice> createState() => _FuncTypeChoiceState();
}

class _FuncTypeChoiceState extends State<FuncTypeChoice> {
  FuncType funcType = FuncType.min;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FuncType>(
      segments: const <ButtonSegment<FuncType>>[
        ButtonSegment<FuncType>(
          value: FuncType.min,
          label: Text('Минимизировать'),
        ),
        ButtonSegment<FuncType>(
          value: FuncType.max,
          label: Text('Максимизировать'),
        ),
      ],
      showSelectedIcon: false,
      selected: <FuncType>{funcType},
      onSelectionChanged: (Set<FuncType> newSelection) {
        setState(() {
          funcType = newSelection.first;
        });
      },
    );
  }
}
