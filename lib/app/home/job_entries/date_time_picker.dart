import 'dart:async';

import 'package:flutter/material.dart';

import 'format.dart';
import 'input_dropdown.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectDateState,
    required this.selectTimeState,
  });

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDateState;
  final ValueChanged<TimeOfDay> selectTimeState;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectDateState(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      selectTimeState(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodySmall;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: Format.date(selectedDate),
            valueStyle: valueStyle!,
            onPressed: () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 18.0),
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
            labelText: '',
          ),
        ),
      ],
    );
  }
}
