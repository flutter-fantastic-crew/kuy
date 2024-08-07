import 'package:flutter/material.dart';
import 'package:flutter_study/enum/date_picker_select_mode.dart';
import 'package:flutter_study/util/datetime_util.dart';
import 'package:flutter_study/view_model/add_plan_view_model.dart';
import 'package:flutter_study/view_model/date_picker_view_model.dart';
import 'package:flutter_study/widget/button_widget.dart';
import 'package:flutter_study/widget/date_picker/date_picker_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomSheetDatePicker extends StatelessWidget {
  const BottomSheetDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      width: 1,
      height: 0.8,
      mode: DatePickerSelectMode.range,
      firstDay: DateTime(DateTime.now().year - 1, 1, 1),
      lastDay: DateTime(DateTime.now().year + 1, 12, 31),
      initDate: context.read<AddPlanViewModel>().selectedDate,
      showDateRangeButton: true,
      header: (context) => Consumer<DatePickerViewModel>(
        builder: (_, datePickerViewModel, __) => SizedBox(
          height: 50,
          child: Column(
            children: [
              if (datePickerViewModel.selectedDateCellList.isEmpty)
                const Text(
                  '시작일을 선택하세요.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                )
              else if (datePickerViewModel.selectedDateCellList.length == 1)
                const Text(
                  '종료일을 선택하세요.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                )
              else
                const Text(
                  '플랜 기간',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: datePickerViewModel.selectedDateCellList.isEmpty,
                    child: const Text(
                      '-',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  if (datePickerViewModel.selectedDateCellList.isNotEmpty) ...[
                    Text(
                      dateFormat(
                          datePickerViewModel.selectedDateCellList.first.date,
                          'MMM dd일'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const Text(
                      ' ~ ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                  if (datePickerViewModel.selectedDateCellList.length > 1) ...[
                    Text(
                      dateFormat(
                          datePickerViewModel.selectedDateCellList.last.date,
                          'MMM dd일'),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      ' (${datePickerViewModel.dateRange}일)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
      ),
      bottom: (context) => Container(
        height: 60,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Color(0xFFD7D7D7),
            ),
          ),
        ),
        child: Consumer<DatePickerViewModel>(
          builder: (_, datePickerViewModel, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => datePickerViewModel.changeScroll(DateTime.now()),
                child: const Text(
                  '오늘로 이동',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              ButtonWidget(
                text: '선택',
                disabled: datePickerViewModel.selectedDateCellList.length <= 1,
                onPressed: () {
                  context.read<AddPlanViewModel>().setSelectedDate(context
                      .read<DatePickerViewModel>()
                      .selectedDateCellList
                      .map((e) => e.date)
                      .toList());
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
