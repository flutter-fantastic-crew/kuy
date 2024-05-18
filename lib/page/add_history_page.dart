import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/enums/date_picker_select_mode.dart';
import 'package:flutter_study/utils/datetime_util.dart';
import 'package:flutter_study/utils/text_input_formatter.dart';
import 'package:flutter_study/view_model/add_history_view_model.dart';
import 'package:flutter_study/widget/date_picker_widget.dart';
import 'package:flutter_study/widget/text_field_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddHistoryPage extends StatelessWidget {
  final String planId;

  const AddHistoryPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddHistoryViewModel(planId),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Column(
              children: [
                const Text(
                  '내역 추가',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                    '${context.read<AddHistoryViewModel>().plan.icon} ${context.read<AddHistoryViewModel>().plan.name}',
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: 17,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => context
                                .read<AddHistoryViewModel>()
                                .setConsumption(),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFF6F6F6),
                              surfaceTintColor: const Color(0xFFF6F6F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(50, 50),
                              padding: const EdgeInsets.all(0),
                            ),
                            child: context
                                    .watch<AddHistoryViewModel>()
                                    .isConsumption
                                ? const Icon(Icons.remove)
                                : const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: TextFieldWidget(
                                onChanged: (value) => context
                                    .read<AddHistoryViewModel>()
                                    .setPriceFieldDeleteIconVisible(),
                                controller: context
                                    .read<AddHistoryViewModel>()
                                    .priceTextController,
                                inputDecoration: InputDecoration(
                                  hintText: context
                                          .watch<AddHistoryViewModel>()
                                          .isConsumption
                                      ? '소비 금액'
                                      : '수입 금액',
                                  hintStyle:
                                      const TextStyle(color: Color(0xFFBEBEBE)),
                                  border: InputBorder.none,
                                  suffixIcon: context
                                          .watch<AddHistoryViewModel>()
                                          .isPriceFieldDeleteIconVisible
                                      ? GestureDetector(
                                          onTap: () {
                                            context
                                                .read<AddHistoryViewModel>()
                                                .priceTextController
                                                .clear();
                                            context
                                                .read<AddHistoryViewModel>()
                                                .setPriceFieldDeleteIconVisible();
                                          },
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Color(0xFFC4C4C4),
                                            size: 20,
                                          ),
                                        )
                                      : null,
                                ),
                                suffix: const Text(
                                  '원',
                                  style: TextStyle(
                                    color: Color(0xFF828282),
                                  ),
                                ),
                                inputFormatters: [
                                  CurrencyInputFormatter(),
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextFieldWidget(
                        inputDecoration: InputDecoration(
                          hintText: '내용',
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: InputBorder.none,
                          suffixIcon: context
                                  .watch<AddHistoryViewModel>()
                                  .isContentFieldDeleteIconVisible
                              ? GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AddHistoryViewModel>()
                                        .contentTextController
                                        .clear();
                                    context
                                        .read<AddHistoryViewModel>()
                                        .setContentFieldDeleteIconVisible();
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Color(0xFFC4C4C4),
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                        onChanged: (value) => context
                            .read<AddHistoryViewModel>()
                            .setContentFieldDeleteIconVisible(),
                        controller: context
                            .read<AddHistoryViewModel>()
                            .contentTextController,
                        prefix: GestureDetector(
                          onTap: () => context
                              .read<AddHistoryViewModel>()
                              .setEmojiPickerVisible(),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Text(
                                context.watch<AddHistoryViewModel>().emoji),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          showDragHandle: false,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) {
                            return DatePickerWidget(
                              width: 1,
                              height: 0.55,
                              mode: DatePickerSelectMode.normal,
                              firstDay: DateTime(DateTime.now().year - 1, 1, 1),
                              lastDay:
                                  DateTime(DateTime.now().year + 1, 12, 31),
                              header: const Text(
                                '날짜 선택',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              initSelectDate:
                                  context.watch<AddHistoryViewModel>().date,
                              onSelected: (oldDate, newDate) {
                                context
                                    .read<AddHistoryViewModel>()
                                    .setDate(newDate);
                                context.pop();
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFFC4C4C4),
                                  ),
                                ),
                                Text(dateFormat(
                                    context.watch<AddHistoryViewModel>().date,
                                    'M월 d일 EEEE')),
                              ],
                            ),
                            isToday(context.watch<AddHistoryViewModel>().date)
                                ? const Text(
                                    '오늘',
                                    style: TextStyle(color: Color(0xFF1773FC)),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Offstage(
                  offstage: !context
                      .watch<AddHistoryViewModel>()
                      .isEmojiPickerVisible,
                  // TODO : 이미지 피커 스타일 수정
                  child: EmojiPicker(onEmojiSelected: (category, emoji) {
                    context
                        .read<AddHistoryViewModel>()
                        .setEmoji(emoji.emoji.toString());
                    context.read<AddHistoryViewModel>().setEmojiPickerVisible();
                  }),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(18),
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1773FC),
                minimumSize: const Size(100, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
