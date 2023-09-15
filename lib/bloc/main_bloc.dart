import 'package:bloc/bloc.dart';
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

  get func => _func;
  get matrix => _matrix;
  get basis => _basis;

  MainBloc() : super(MainInitial()) {
    on<MainEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void updateFunc(Map<int, String> newFunc) => _func = newFunc;
  void updateMatrix(List<List<String>> newMatrix) => _matrix = newMatrix;
  void updateBasis(List<String> newBasis) => _basis = newBasis;
}
