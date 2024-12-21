import 'package:flutter/material.dart';

Future<TimeOfDay?> dialogTimePicker(BuildContext context,
    {TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    TimeOfDay? initialTime,
    Orientation? orientation,
    bool alwaysUse24HourFormat = true,
    TextDirection? textDirection,
    MaterialTapTargetSize? materialTapTargetSize}) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    initialEntryMode: initialEntryMode,
    orientation: orientation,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: Directionality(
          textDirection: textDirection ?? TextDirection.ltr,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: alwaysUse24HourFormat,
            ),
            child: child!,
          ),
        ),
      );
    },
  );
}
