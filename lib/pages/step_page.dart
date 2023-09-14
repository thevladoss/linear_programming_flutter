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
            'Шаг ${step.matrix[0][0]}',
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.symmetric(inside: BorderSide()),
          defaultColumnWidth: const FixedColumnWidth(66),
          children: [
            TableRow(
              children: [
                _buildTableItem('gay', context, weight: FontWeight.bold),
                _buildTableItem('gay', context, weight: FontWeight.bold),
                _buildTableItem('gay', context, weight: FontWeight.bold),
              ],
            ),
            TableRow(
              children: [
                _buildTableItem('gay', context, weight: FontWeight.bold),
                _buildTableItem('gay', context, color: Colors.indigo.shade100),
                _buildTableItem('gay', context),
              ],
            ),
            TableRow(
              children: [
                _buildTableItem('gay', context, weight: FontWeight.bold),
                _buildTableItem('gay', context),
                _buildTableItem('gay', context),
              ],
            ),
          ],
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
