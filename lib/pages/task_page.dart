import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_flutter/bloc/main_bloc.dart';
import 'package:linear_flutter/models/enums.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _vars = 5;
  int _limits = 3;
  Map<int, String> _func = {};
  List<List<String>> _matrix = [];
  List<String> _basis = [];

  @override
  Widget build(BuildContext context) {
    _func = context.read<MainBloc>().func;
    _matrix = context.read<MainBloc>().matrix;
    _basis = context.read<MainBloc>().basis;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Введите задачу',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Переменные',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    NumberStepper(
                      initialValue: _vars,
                      minValue: _limits + 1,
                      maxValue: 16,
                      step: 1,
                      onChanged: (value) {
                        if (_vars != value) {
                          setState(() {
                            _vars = value;
                            if (_vars > _func.length) {
                              _func.addAll({_vars: '0'});
                              _basis.add('0');
                              List<List<String>> newList = [];
                              for (List<String> list in _matrix) {
                                List<String> l = list.toList();
                                l.add('0');
                                newList.add(l);
                              }
                              _matrix = newList;
                            } else {
                              _func.removeWhere(
                                  (key, value) => key == _func.length);
                              _basis.removeLast();
                              List<List<String>> newList = [];
                              for (List<String> list in _matrix) {
                                List<String> l = list.toList();
                                l.removeLast();
                                newList.add(l);
                              }
                              _matrix = newList;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Ограничения',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    NumberStepper(
                      initialValue: _limits,
                      minValue: 1,
                      maxValue: _vars - 1,
                      step: 1,
                      onChanged: (value) {
                        if (_limits != value) {
                          setState(() {
                            _limits = value;
                            if (_limits > _matrix.length) {
                              _matrix.add(List.filled(_vars + 1, '0'));
                            } else {
                              _matrix.removeLast();
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Дроби',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const NumberTypeChoice(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Функция',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const FuncTypeChoice(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Способ решения',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const AutomaticChoice(),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Базис заполнять необязательно',
                    ),
                  ],
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Таблица',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                        child: _buildLimitsInputTable(_limits, _vars + 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildLimitsInputTable(int rows, int columns) {
    List<TableRow> table = [
      TableRow(
        children: List.generate(
          columns,
          (column) => (column == 0)
              ? Container()
              : (column == columns - 1)
                  ? const SizedBox()
                  : Center(
                      child: Text(
                        'c$column',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
        ),
      ),
      TableRow(
        children: List.generate(
          columns,
          (column) => (column == 0)
              ? Center(
                  child: Text(
                    'f(x)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                )
              : (column == columns - 1)
                  ? const SizedBox()
                  : _buildInputMatrixItem(1, column),
        ),
      ),
      TableRow(
        children: List.generate(
          columns,
          (column) => (column == 0)
              ? Container()
              : (column == columns - 1)
                  ? Center(
                      child: Text(
                      'b',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ))
                  : Center(
                      child: Text(
                        'a$column',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
        ),
      )
    ];

    table.addAll(
      List.generate(
        rows,
        (row) => TableRow(
          children: List.generate(
            columns,
            (column) => (column == 0)
                ? Center(
                    child: Text(
                      'f${row + 1}(x)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  )
                : _buildInputMatrixItem(row + 3, column),
          ),
        ),
      ),
    );

    table.add(
      TableRow(
        children: List.generate(
            columns,
            (column) => (column == 0)
                ? Text(
                    'Базис',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : const SizedBox()),
      ),
    );

    table.add(
      TableRow(
        children: List.generate(
            columns,
            (column) => (column == 0)
                ? Center(
                    child: Text(
                      '<',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 25),
                    ),
                  )
                : (column == columns - 1)
                    ? Center(
                        child: Text(
                          '>',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                      )
                    : _buildInputMatrixItem(_vars + 3, column)),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          defaultColumnWidth: const FixedColumnWidth(66),
          children: table,
        ),
      ),
    );
  }

  Padding _buildInputMatrixItem(int i, int j) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          controller: TextEditingController(
            text: (i == 1)
                ? _func[j]
                : (i == _vars + 3 && _basis[j - 1] != '0')
                    ? _basis[j - 1]
                    : (i == _vars + 3 && _basis[j - 1] == '0')
                        ? ''
                        : _matrix[i - 3][j - 1],
          ),
          onChanged: (value) {
            if (i == 1) {
              _func[j] = value;
            } else if (i == _vars + 3) {
              _basis[j - 1] = value;
            } else {
              _matrix[i - 3][j - 1] = value;
            }
          },
        ),
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

class AutomaticChoice extends StatefulWidget {
  const AutomaticChoice({super.key});

  @override
  State<AutomaticChoice> createState() => _AutomaticChoiceState();
}

class _AutomaticChoiceState extends State<AutomaticChoice> {
  FuncType funcType = FuncType.min;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FuncType>(
      segments: const <ButtonSegment<FuncType>>[
        ButtonSegment<FuncType>(
          value: FuncType.min,
          label: Text('Автоматический'),
        ),
        ButtonSegment<FuncType>(
          value: FuncType.max,
          label: Text('Пошаговый'),
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
