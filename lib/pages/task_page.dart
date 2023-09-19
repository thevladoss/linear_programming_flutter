import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linear_flutter/bloc/app_bloc.dart';
import 'package:linear_flutter/models/enums.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  int _vars = 1;
  int _limits = 1;
  Map<int, String> _func = {};
  List<List<String>> _matrix = [];
  List<bool> _basis = [];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vars = context.read<AppBloc>().task.vars;
    _limits = context.read<AppBloc>().task.limits;
    _func = context.read<AppBloc>().task.func;
    _matrix = context.read<AppBloc>().task.matrix;
    _basis = context.read<AppBloc>().task.basis;

    return (MediaQuery.of(context).size.width <= 500)
        ? _buildMobile(context)
        : _buildDesktop(context);
  }

  Padding _buildMobile(BuildContext context) {
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
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Настройки',
              ),
              Tab(
                text: 'Данные',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildLeftSide(context),
                _buildRightSide(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildRightSide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Входные данные',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          child: _buildLimitsInputTable(_limits, _vars + 2),
        ),
      ],
    );
  }

  SingleChildScrollView _buildLeftSide(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    _basis.add(false);
                    List<List<String>> newList = [];
                    for (List<String> list in _matrix) {
                      List<String> l = list.toList();
                      l.add('0');
                      newList.add(l);
                    }
                    _matrix = newList;
                  } else {
                    _func.removeWhere((key, value) => key == _func.length);
                    _basis.removeLast();
                    List<List<String>> newList = [];
                    for (List<String> list in _matrix) {
                      List<String> l = list.toList();
                      l.removeLast();
                      newList.add(l);
                    }
                    _matrix = newList;
                  }
                  context.read<AppBloc>().updateVars(_vars);
                  context.read<AppBloc>().updateFunc(_func);
                  context.read<AppBloc>().updateMatrix(_matrix);
                  context.read<AppBloc>().updateBasis(_basis);
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
                  context.read<AppBloc>().updateLimits(_limits);
                  context.read<AppBloc>().updateMatrix(_matrix);
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
    );
  }

  Padding _buildDesktop(BuildContext context) {
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
                _buildLeftSide(context),
                const SizedBox(
                  width: 40,
                ),
                Expanded(child: _buildRightSide(context)),
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                    )
                  : Checkbox(
                      value: _basis[column - 1],
                      onChanged: (bool? value) {
                        setState(() {
                          _basis[column - 1] = value!;

                          context.read<AppBloc>().updateBasis(_basis);
                        });
                      },
                    ),
        ),
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
            text: (i == 1) ? _func[j] : _matrix[i - 3][j - 1],
          ),
          onChanged: (value) {
            if (i == 1) {
              _func[j] = value;
              context.read<AppBloc>().updateFunc(_func);
            } else {
              _matrix[i - 3][j - 1] = value;
              context.read<AppBloc>().updateMatrix(_matrix);
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
  NumberType _numberType = NumberType.fraction;

  @override
  Widget build(BuildContext context) {
    _numberType = context.read<AppBloc>().task.numberType;
    return SegmentedButton<NumberType>(
      segments: const <ButtonSegment<NumberType>>[
        ButtonSegment<NumberType>(
          value: NumberType.fraction,
          label: Text('Обыкновенные'),
        ),
        ButtonSegment<NumberType>(
          value: NumberType.decimal,
          label: Text('Десятичные'),
        ),
      ],
      showSelectedIcon: false,
      selected: <NumberType>{_numberType},
      onSelectionChanged: (Set<NumberType> newSelection) {
        setState(() {
          context.read<AppBloc>().updateNumberType(newSelection.first);
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
  FuncType _funcType = FuncType.min;

  @override
  Widget build(BuildContext context) {
    _funcType = context.read<AppBloc>().task.funcType;
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
      selected: <FuncType>{_funcType},
      onSelectionChanged: (Set<FuncType> newSelection) {
        setState(() {
          context.read<AppBloc>().updateFuncType(newSelection.first);
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
  AnswerType _answerType = AnswerType.step;

  @override
  Widget build(BuildContext context) {
    _answerType = context.read<AppBloc>().task.answerType;
    return SegmentedButton<AnswerType>(
      segments: const <ButtonSegment<AnswerType>>[
        ButtonSegment<AnswerType>(
          value: AnswerType.step,
          label: Text('Пошаговый'),
        ),
        ButtonSegment<AnswerType>(
          value: AnswerType.auto,
          label: Text('Автоматический'),
        ),
      ],
      showSelectedIcon: false,
      selected: <AnswerType>{_answerType},
      onSelectionChanged: (Set<AnswerType> newSelection) {
        setState(() {
          context.read<AppBloc>().updateAnswerType(newSelection.first);
        });
      },
    );
  }
}
