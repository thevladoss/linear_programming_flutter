import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fraction/fraction.dart';
import 'package:linear_flutter/models/enums.dart';
import 'package:linear_flutter/models/step_data.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final Task _task = Task(
    //func: {1: '0', 2: '0', 3: '0', 4: '0', 5: '0'},
    func: {1: '-5', 2: '-4', 3: '-3', 4: '-2', 5: '3'},
    matrix: [
      ['2', '1', '1', '1', '-1', '3'],
      ['1', '-1', '0', '1', '1', '1'],
      ['-2', '-1', '-1', '1', '0', '1']
    ],
    /*matrix: [
      ['0', '0', '0', '0', '0', '0'],
      ['0', '0', '0', '0', '0', '0'],
      ['0', '0', '0', '0', '0', '0']
    ],*/
    basis: [false, false, false, false, false],
    numberType: NumberType.fraction,
    funcType: FuncType.min,
    answerType: AnswerType.step,
    vars: 5,
    limits: 3,
    steps: [],
  );

  int _currentStep = 0;
  bool _isAnimation = false;

  String _error = '';

  get currentStep => _currentStep;
  get task => _task;
  get isAnimation => _isAnimation;

  MainBloc() : super(MainTaskState()) {
    on<MainEvent>((event, emit) {
      if (event is MainSwitchPageEvent) {
        if (event.index == 0) {
          _currentStep = 0;
          _task.clear();
          emit(MainTaskState());
        } else if (event.index == 1) {
          if (event.step == null) {
            _currentStep = 0;
            emit(MainBasisState(step: _task.steps.first));
          } else {
            emit(MainBasisState(step: event.step!));
          }
        } else if (event.index == 2) {
          if (event.step == null) {
            _currentStep = _task.getIndexOfBasis();
            emit(MainSimplexState(step: _task.steps[_currentStep]));
          } else {
            emit(MainSimplexState(step: event.step!));
          }
        } else if (event.index == 3) {
          if (event.step == null) {
            _currentStep = _task.getIndexOfAnswer();
            emit(MainAnswerState(step: _task.steps[_currentStep]));
          } else {
            emit(MainAnswerState(step: event.step!));
          }
        } else {
          emit(MainGraphState());
        }
      } else if (event is MainCheckTaskEvent) {
        StepData? firstStep = _toStepData();

        if (firstStep == null) {
          _showError(event.context);
        } else {
          _task.addStep(firstStep);

          add(MainSwitchPageEvent(index: 1, step: _task.steps[_currentStep]));
          if (_task.answerType == AnswerType.auto) {
            _isAnimation = true;
            Future.delayed(const Duration(seconds: 1), () {
              add(MainNextStepEvent());
            });
          }
        }
      } else if (event is MainNextStepEvent) {
        _currentStep++;

        if (_currentStep >= _task.steps.length) {
          _task.addStep(nextStep(_task.steps[currentStep - 1]));
        }

        _updateWhenSwitchStep();
      } else if (event is MainPrevStepEvent) {
        _currentStep--;

        _updateWhenSwitchStep();
      } else if (event is MainChangeElementEvent && !_isAnimation) {
        _task.steps[_currentStep].element = event.newElem;
        _task.removeStep(_currentStep + 1, _task.steps.length);

        add(MainSwitchPageEvent(
            index: event.index, step: _task.steps[_currentStep]));
      } else if (event is MainReloadAppEvent) {
        _showRemoveDialog(event.context);
      } else if (event is MainShowHelpEvent) {
        _showHelpBottomSheet(event.context);
      }
    });
  }

  _updateWhenSwitchStep() {
    if (_task.steps[_currentStep].basis != null &&
        _task.steps[_currentStep].answer == null) {
      add(MainSwitchPageEvent(index: 2, step: _task.steps[_currentStep]));
      if (_task.answerType == AnswerType.auto && _isAnimation) {
        Future.delayed(const Duration(seconds: 1), () {
          add(MainNextStepEvent());
        });
      }
    } else if (_task.steps[_currentStep].basis != null &&
        _task.steps[_currentStep].answer != null) {
      _isAnimation = false;
      add(MainSwitchPageEvent(index: 3, step: _task.steps[_currentStep]));
    } else {
      add(MainSwitchPageEvent(index: 1, step: _task.steps[_currentStep]));
      if (_task.answerType == AnswerType.auto && _isAnimation) {
        Future.delayed(const Duration(seconds: 1), () {
          add(MainNextStepEvent());
        });
      }
    }
  }

  _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.only(right: 60, left: 145, bottom: 15),
        content: Text(_error),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Справка',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'Количество перменных не превышает 16.\nKоличество ограничений строго меньше числа переменных.\nВводимые данные имеют следущие ограничения: все c <> 0, все b >= 0.\n\nИспользуйте боковые клавиши сверху для очистки, записи в файл и чтения из файла.\nИспользуйте боковые клавиши снизу для перемещения между этапами решения:\n   1 - для метода искусственного базиса\n   2 - основное решение\n   3 - финальный ответ\n\nВы можете выбрать зависимые переменные базиса.\nЕсли поля базиса останутся не заполненными, то задача будет решена методом искусственного базиса.\nПри введении базиса решение перейдёт сразу на 2 этап.\nИспользуйте автоматический режим для перехода сразу на 3 этап.\n\nИспользуйте стрелки для перемещения между шагами решения.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton.tonal(
                      child: const Text('Закрыть'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showRemoveDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Предупреждение'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Вы уверены, что хотите очистить все поля и текущее решение задачи?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: const Text('Да'),
              onPressed: () {
                Phoenix.rebirth(context);
              },
            ),
          ],
        );
      },
    );
  }

  StepData? _toStepData() {
    StepData startData = StepData(func: {}, matrix: [
      [0.toFraction()]
    ]);
    try {
      for (int i = 1; i <= _task.vars; i++) {
        startData.matrix[0].add(i.toFraction().reduce());
        if (_task.func[i] == 0.toString()) {
          _error = 'incorrectTaskData';
          break;
        }
        startData.func[i] = Fraction.fromString(_task.func[i]!);
        if (_task.funcType == FuncType.max) {
          startData.func[i] = (-1).toFraction() * startData.func[i]!;
        }
      }
      startData.matrix[0].add(0.toFraction().reduce());
      for (int i = 0; i < _task.matrix.length; i++) {
        startData.matrix.add([]);
        for (int j = 0; j < _task.matrix[0].length; j++) {
          startData.matrix[i + 1].add(_task.matrix[i][j].toFraction().reduce());
        }
      }
      for (int i = 1; i < startData.matrix.length; i++) {
        if (startData.matrix[i][startData.matrix[i].length - 1].toDouble() <
            0) {
          _error = 'incorrectTaskData';
        }
      }
      if (_task.basis.contains(true)) {
        startData = startData.copyWith(basis: []);
        for (int i = 0; i < _task.basis.length; i++) {
          if (_task.basis[i]) {
            startData.basis?.add(1.toFraction());
          } else {
            startData.basis?.add(0.toFraction());
          }
        }
      }
      if (startData.basis == null) {
        for (int i = 1; i < startData.matrix.length; i++) {
          startData.matrix[i]
              .insert(0, (_task.func.length + i).toFraction().reduce());
        }
        startData.matrix.add([0.toFraction()]);
        for (int i = 1; i < startData.matrix[0].length; i++) {
          Fraction sum = 0.toFraction();
          for (int j = 1; j < startData.matrix.length - 1; j++) {
            sum += startData.matrix[j][i];
          }
          startData.matrix[startData.matrix.length - 1]
              .add((-1).toFraction() * sum);
        }
      } else {
        int basisCount = 0;
        List<int> basisVars = [];
        for (int i = 0; i < _task.basis.length; i++) {
          if (_task.basis[i]) {
            basisCount += 1;
            basisVars.add(i + 1);
          }
        }
        if (basisCount != startData.matrix.length - 1) {
          _error = 'incorrectBasis';
        }
        for (int i = 1; i < startData.matrix.length; i++) {
          startData.matrix[i].insert(0, 0.toFraction().reduce());
        }
        for (int i = 0; i < basisCount; i++) {
          startData.matrix[0].insert(task.vars + 1, basisVars[i].toFraction());
          for (int j = 1; j < startData.matrix.length; j++) {
            startData.matrix[j].insert(
                task.vars + 1,
                startData.matrix[j]
                    [startData.matrix[0].indexOf((basisVars[i].toFraction()))]);
            startData.matrix[j].removeAt(
                startData.matrix[0].indexOf((basisVars[i].toFraction())));
          }
          startData.matrix[0].removeAt(
              startData.matrix[0].indexOf((basisVars[i].toFraction())));
        }
        for (int i = 1; i <= basisCount; i++) {
          Fraction del = startData.matrix[i][task.vars - basisCount + i];
          startData.matrix[i] = [
            for (var e in startData.matrix[i]) (e / del).reduce()
          ];
          for (int j = i + 1; j < startData.matrix.length; j++) {
            Fraction m = startData.matrix[j][task.vars - basisCount + i];
            for (int l = 1; l < startData.matrix[0].length; l++) {
              startData.matrix[j][l] -= startData.matrix[i][l] * m;
              startData.matrix[j][l].reduce();
            }
          }
        }
        for (int i = basisCount; i > 1; i--) {
          for (int j = 1; j < i; j++) {
            Fraction m = startData.matrix[j][task.vars - basisCount + i];
            for (int l = 1; l < startData.matrix[0].length; l++) {
              startData.matrix[j][l] -= startData.matrix[i][l] * m;
              startData.matrix[j][l] = startData.matrix[j][l].reduce();
            }
          }
        }
        for (int i = 0; i < basisCount; i++) {
          startData.matrix[i + 1][0] = basisVars[i].toFraction();
          startData.basis![basisVars[i] - 1] =
              startData.matrix[i + 1][startData.matrix[0].length - 1];
        }
        for (int i = task.vars - basisCount + 1; i <= task.vars; i++) {
          for (int j = 0; j < startData.matrix.length; j++) {
            startData.matrix[j].removeAt(task.vars - basisCount + 1);
          }
        }
        startData.matrix.add([]);
        for (int i = 0; i < startData.matrix[0].length; i++) {
          startData.matrix[startData.matrix.length - 1].add(0.toFraction());
        }
        for (int i = 1; i < startData.matrix[0].length - 1; i++) {
          startData.matrix[startData.matrix.length - 1][i] += startData
              .func.entries
              .firstWhere((entry) =>
                  entry.key == startData.matrix[0][i].toDouble().toInt())
              .value;
        }

        for (int i = 1; i < startData.matrix[0].length - 1; i++) {
          for (int j = 1; j < startData.matrix.length - 1; j++) {
            startData.matrix[startData.matrix.length - 1][i] += (-1)
                    .toFraction() *
                startData.matrix[j][i] *
                startData.func.entries
                    .firstWhere((entry) =>
                        entry.key == startData.matrix[j][0].toDouble().toInt())
                    .value;
          }
          startData.matrix[startData.matrix.length - 1][i] =
              startData.matrix[startData.matrix.length - 1][i].reduce();
        }
        for (int i = 1; i < startData.matrix.length - 1; i++) {
          startData.matrix[startData.matrix.length - 1]
              [startData.matrix[0].length - 1] += (-1)
                  .toFraction() *
              startData.matrix[i][startData.matrix[0].length - 1] *
              startData.func.entries
                  .firstWhere((entry) =>
                      entry.key == startData.matrix[i][0].toDouble().toInt())
                  .value;
        }
        startData =
            startData.copyWith(element: startData.getPossibleElements()[0]);
      }
      if (startData.getPossibleElements().length > 0) {
        startData =
            startData.copyWith(element: startData.getPossibleElements()[0]);
      } else {
        startData.element = [0, 0];
      }
    } catch (e) {
      _error = e.toString();
      return null;
    }
    return startData;
  }

  StepData nextStep(StepData previousData) {
    List<List<Fraction>> newMatrix = [];
    for (List<Fraction> elem in previousData.matrix) {
      newMatrix.add([...elem]);
    }
    StepData nextData = StepData(
        func: previousData.func,
        matrix: newMatrix,
        element: previousData.element,
        basis: previousData.basis,
        answer: previousData.answer);
    if (nextData.matrix[nextData.matrix.length - 1]
                    [nextData.matrix[0].length - 1]
                .toDouble() ==
            0 &&
        nextData.matrix[nextData.matrix.length - 1][0].toDouble() == 0) {
      if (nextData.basis == null) {
        nextData = nextData.copyWith(basis: []);
        for (int i = 1; i <= nextData.func.length; i++) {
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            if (nextData.matrix[j][0].toDouble() == i) {
              nextData.basis!.add(
                  nextData.matrix[j][nextData.matrix[0].length - 1].reduce());
              break;
            }
            if (j == nextData.matrix.length - 2) {
              nextData.basis!.add(0.toFraction());
            }
          }
        }
      }
      for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
        nextData.matrix[nextData.matrix.length - 1][i] += nextData.func.entries
            .firstWhere((entry) =>
                entry.key == nextData.matrix[0][i].toDouble().toInt())
            .value;
      }

      for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          nextData.matrix[nextData.matrix.length - 1][i] += (-1).toFraction() *
              nextData.matrix[j][i] *
              nextData.func.entries
                  .firstWhere((entry) =>
                      entry.key == nextData.matrix[j][0].toDouble().toInt())
                  .value;
        }
        nextData.matrix[nextData.matrix.length - 1][i] =
            nextData.matrix[nextData.matrix.length - 1][i].reduce();
      }
      for (int i = 1; i < nextData.matrix.length - 1; i++) {
        nextData.matrix[nextData.matrix.length - 1]
                [nextData.matrix[0].length - 1] +=
            (-1).toFraction() *
                nextData.matrix[i][nextData.matrix[0].length - 1] *
                nextData.func.entries
                    .firstWhere((entry) =>
                        entry.key == nextData.matrix[i][0].toDouble().toInt())
                    .value;
      }
      nextData.matrix[nextData.matrix.length - 1]
              [nextData.matrix[0].length - 1] =
          nextData.matrix[nextData.matrix.length - 1]
                  [nextData.matrix[0].length - 1]
              .reduce();
      nextData.matrix[0][0] = 0.toFraction();
    } else {
      /*if (nextData.matrix[nextData.matrix.length - 1][0].toDouble() != 0) {
        nextData.matrix.add([0.toFraction()]);
        for (int i = 1; i < nextData.matrix[0].length; i++) {
          Fraction sum = 0.toFraction();
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            sum += nextData.matrix[j][i];
          }
          nextData.matrix[nextData.matrix.length - 1]
              .add((-1).toFraction() * sum);
        }
      } else {*/
      nextData.matrix[0][0] += 1.toFraction();
      Fraction swap = nextData.matrix[0][nextData.element![1]];
      nextData.matrix[0][nextData.element![1]] =
          nextData.matrix[nextData.element![0]][0];
      nextData.matrix[nextData.element![0]][0] = swap;
      nextData.matrix[nextData.element![0]][nextData.element![1]] =
          nextData.matrix[nextData.element![0]][nextData.element![1]].inverse();
      for (int i = 1; i < nextData.matrix[nextData.element![0]].length; i++) {
        if (i != nextData.element![1]) {
          nextData.matrix[nextData.element![0]][i] *=
              nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
        nextData.matrix[nextData.element![0]][i] =
            nextData.matrix[nextData.element![0]][i].reduce();
      }
      for (int x = 1; x < nextData.matrix.length; x++) {
        for (int y = 1; y < nextData.matrix[x].length; y++) {
          if (x != nextData.element![0] && y != nextData.element![1]) {
            nextData.matrix[x][y] -= nextData.matrix[x][nextData.element![1]] *
                nextData.matrix[nextData.element![0]][y];
            nextData.matrix[x][y] = nextData.matrix[x][y].reduce();
          }
        }
      }
      for (int i = 1; i < nextData.matrix.length; i++) {
        if (i != nextData.element![0]) {
          nextData.matrix[i][nextData.element![1]] *= (-1).toFraction() *
              nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
        nextData.matrix[i][nextData.element![1]] =
            nextData.matrix[i][nextData.element![1]].reduce();
      }
      for (int i = 1; i < nextData.matrix[0].length; i++) {
        if (nextData.matrix[0][i].toDouble() > nextData.func.length) {
          for (int j = 0; j < nextData.matrix.length; j++) {
            nextData.matrix[j].removeAt(i);
          }
          break;
        }
      }
      //}
    }
    Fraction elementValue = 0.toFraction();
    nextData = nextData.copyWith(element: [0, 0]);
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      if (nextData.matrix[nextData.matrix.length - 1][i].toDouble() < 0) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          if (nextData.matrix[j][i].toDouble() > 0) {
            if ((nextData.matrix[j][nextData.matrix[0].length - 1] /
                            nextData.matrix[j][i] <
                        elementValue ||
                    elementValue.toDouble() == 0) &&
                ((nextData.basis == null &&
                        nextData.matrix[j][0].toDouble() >
                            nextData.func.length) ||
                    nextData.basis != null)) {
              elementValue = nextData.matrix[j][nextData.matrix[0].length - 1] /
                  nextData.matrix[j][i];
              nextData.element![0] = j;
              nextData.element![1] = i;
            }
          }
        }
      }
    }

    for (int i = 1; i < nextData.matrix[0].length; i++) {
      if (nextData.matrix[nextData.matrix.length - 1][i] < 0.toFraction() ||
          nextData.basis == null) {
        break;
      }
      if (i == nextData.matrix[0].length - 1) {
        nextData = nextData.copyWith(
            answer: ((-1).toFraction() *
                    nextData.matrix[nextData.matrix.length - 1][i])
                .reduce(),
            basis: []);
        for (int i = 1; i <= nextData.func.length; i++) {
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            if (nextData.matrix[j][0].toDouble() == i) {
              nextData.basis!.add(
                  nextData.matrix[j][nextData.matrix[0].length - 1].reduce());
              break;
            }
            if (j == nextData.matrix.length - 2) {
              nextData.basis!.add(0.toFraction());
            }
          }
        }
      }
    }
    return nextData;
  }

  void updateVars(int newVars) => task.vars = newVars;
  void updateLimits(int newLimits) => task.limits = newLimits;
  void updateFunc(Map<int, String> newFunc) => _task.func = newFunc;
  void updateMatrix(List<List<String>> newMatrix) => _task.matrix = newMatrix;
  void updateBasis(List<bool> newBasis) => _task.basis = newBasis;
  void updateNumberType(NumberType newNumberType) =>
      _task.numberType = newNumberType;
  void updateFuncType(FuncType newFuncType) => _task.funcType = newFuncType;
  void updateAnswerType(AnswerType newAnswerType) =>
      _task.answerType = newAnswerType;
}
