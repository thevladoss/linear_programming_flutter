import 'package:bloc/bloc.dart';
import 'package:fraction/fraction.dart';
import 'package:linear_flutter/models/enums.dart';
import 'package:linear_flutter/models/step_data.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  Map<int, String> _func = {1: '0', 2: '0', 3: '0', 4: '0', 5: '0'};
  List<List<String>> _matrix = [
    ['0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0']
  ];
  List<String> _basis = ['0', '0', '0', '0', '0'];
  NumberType _numberType = NumberType.fraction;
  FuncType _funcType = FuncType.min;
  AnswerType _answerType = AnswerType.step;

  List<StepData> _steps = [];

  get func => _func;
  get matrix => _matrix;
  get basis => _basis;
  get numberType => _numberType;
  get funcType => _funcType;
  get answerType => _answerType;

  MainBloc() : super(MainTaskState()) {
    on<MainEvent>((event, emit) {
      if (event is MainSwitchPageEvent) {
        if (event.index == 0) {
          emit(MainTaskState());
        } else if (event.index == 1) {
          emit(MainBasisState());
        } else if (event.index == 2) {
          emit(MainSimplexState());
        } else if (event.index == 3) {
          emit(MainAnswerState());
        } else {
          emit(MainGraphState());
        }
      }
    });
  }

  void toStepData() {
    try {
      StepData startData = StepData(func: {}, matrix: [
        [0.toFraction()]
      ], varsCount: _func.length, type: NumberType.fraction);
      for (int i = 1; i <= startData.varsCount; i++) {
        startData.matrix[0].add(i.toFraction().reduce());
        if (_func[i - 1] == 0.toString()) {
          break;
        }
        startData.func[i] = Fraction.fromString(_func[i - 1]!).toDouble();
      }
      startData.matrix[0].add(0.toFraction().reduce());
      for (int i = 0; i < _matrix.length; i++) {
        startData.matrix.add([]);
        for (int j = 0; j < _matrix[0].length; j++) {
          startData.matrix[i + 1].add(_matrix[i][j].toFraction().reduce());
        }
      }
      for (int i = 1; i < startData.matrix.length; i++) {
        if (startData.matrix[i][startData.matrix[i].length - 1].toDouble() <
            0) {}
      }
      if (startData.basis == null) {
        for (int i = 1; i < startData.matrix.length; i++) {
          startData.matrix[i]
              .insert(0, (_func.length + i).toFraction().reduce());
        }
      }
    } finally {}
  }

  StepData nextStep(StepData previousData) {
    StepData nextData = previousData.copyWith();
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
            .value
            .toFraction();
      }

      for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          nextData.matrix[nextData.matrix.length - 1][i] += (-1).toFraction() *
              nextData.matrix[j][i] *
              nextData.func.entries
                  .firstWhere((entry) =>
                      entry.key == nextData.matrix[j][0].toDouble().toInt())
                  .value
                  .toFraction();
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
                    .value
                    .toFraction();
      }
      nextData.matrix[0][0] = 0.toFraction();
    } else {
      if (nextData.matrix[nextData.matrix.length - 1][0].toDouble() != 0) {
        nextData.matrix.add([0.toFraction()]);
        for (int i = 1; i < nextData.matrix[0].length; i++) {
          Fraction sum = 0.toFraction();
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            sum += nextData.matrix[j][i];
          }
          nextData.matrix[nextData.matrix.length - 1]
              .add((-1).toFraction() * sum);
        }
      } else {
        nextData.matrix[0][0] += 1.toFraction();
        Fraction swap = nextData.matrix[0][nextData.element![1]];
        nextData.matrix[0][nextData.element![1]] =
            nextData.matrix[nextData.element![0]][0];
        nextData.matrix[nextData.element![0]][0] = swap;
        nextData.matrix[nextData.element![0]][nextData.element![1]] = nextData
            .matrix[nextData.element![0]][nextData.element![1]]
            .inverse();
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
              nextData.matrix[x][y] -= nextData.matrix[x]
                      [nextData.element![1]] *
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
      }
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
            answer:
                -1 * nextData.matrix[nextData.matrix.length - 1][i].toDouble());
      }
    }

    // print(nextData);
    // print(nextData.getPossibleElements());
    // if (nextData.answer == null) {
    //   nextData = step(nextData);
    // }
    return nextData;
  }

  void updateFunc(Map<int, String> newFunc) => _func = newFunc;
  void updateMatrix(List<List<String>> newMatrix) => _matrix = newMatrix;
  void updateBasis(List<String> newBasis) => _basis = newBasis;
  void updateNumberType(NumberType newNumberType) =>
      _numberType = newNumberType;
  void updateFuncType(FuncType newFuncType) => _funcType = newFuncType;
  void updateAnswerType(AnswerType newAnswerType) =>
      _answerType = newAnswerType;
}
