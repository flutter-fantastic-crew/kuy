import 'package:flutter/material.dart';
import 'package:flutter_study/enum/date_cell_status.dart';
import 'package:flutter_study/util/datetime_util.dart';
import 'package:flutter_study/view_model/date_picker_date_cell_view_model.dart';
import 'package:flutter_study/view_model/date_picker_view_model.dart';
import 'package:provider/provider.dart';

class CalendarDateCell extends StatelessWidget {
  final DateTime date;

  const CalendarDateCell({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DateCellViewModel>(
      create: (_) {
        DateCellViewModel viewModel = DateCellViewModel(date: date);
        context.read<DatePickerViewModel>().addDateCell(viewModel);

        if (context.read<DatePickerViewModel>().initSelectDate != null &&
            isSameDate(
                context.read<DatePickerViewModel>().initSelectDate!, date)) {
          context.read<DatePickerViewModel>().selectedDate(viewModel);
        }

        return viewModel;
      },
      builder: (context, child) {
        return Expanded(
          child: GestureDetector(
            onTap: () => _onTap(context, date),
            child: Container(
              decoration:
                  _cellDecoration(context.watch<DateCellViewModel>().status),
              child: Container(
                padding: const EdgeInsets.all(14),
                alignment: Alignment.center,
                decoration: context.watch<DateCellViewModel>().status !=
                            DateCellStatus.none &&
                        context.watch<DateCellViewModel>().status !=
                            DateCellStatus.includeDate
                    ? const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Text(
                  date.day.toString(),
                  style: context.watch<DateCellViewModel>().status !=
                              DateCellStatus.none &&
                          context.watch<DateCellViewModel>().status !=
                              DateCellStatus.includeDate
                      ? const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                      : isToday(date)
                          ? const TextStyle(
                              color: Color(0xFF1871FF),
                              fontWeight: FontWeight.bold,
                            )
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _onTap(BuildContext context, DateTime date) {
  context.read<DatePickerViewModel>().onSelected?.call(date);
  context
      .read<DatePickerViewModel>()
      .selectedDate(context.read<DateCellViewModel>());
}

BoxDecoration _cellDecoration(DateCellStatus status) {
  switch (status) {
    case DateCellStatus.startDate:
      return const BoxDecoration(
        color: Color(0xFFECECEC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
      );
    case DateCellStatus.endDate:
      return const BoxDecoration(
        color: Color(0xFFECECEC),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      );
    case DateCellStatus.includeDate:
      return const BoxDecoration(
        color: Color(0xFFECECEC),
      );
    default:
      return const BoxDecoration();
  }
}
