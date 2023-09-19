import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';
import '../models/enums.dart';

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
