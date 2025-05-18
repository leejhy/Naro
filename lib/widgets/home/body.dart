import 'package:flutter/material.dart';
import 'package:naro/services/letter_notifier.dart';
import 'package:naro/widgets/home/header_section.dart';
import 'package:naro/widgets/home/letter_view/letter_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/home/letter_filter.dart';
import 'package:naro/utils/letter_utils.dart';
import 'package:naro/models/letter_filter.dart';


class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key,});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  LetterFilter _filter = LetterFilter.all;

  @override
  Widget build(BuildContext context) {
    final letters = ref.watch(letterNotifierProvider);

    return letters.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
      data: (letters) {
        final (nextDate: nextDate, dDay: dDay) = extractUpcomingLetterInfo(letters);
        final filtered = filterLetters(letters, _filter);

        return Container(
          decoration: BoxDecoration(
            gradient: UIColors.backgroundGradient,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              HeaderSection(
                dDay: dDay,
                arrivalDate: nextDate,
                letterCount: letters.length,
              ),
              SliverToBoxAdapter(
                child: LetterSortingButtons(
                  current: _filter,
                  onChanged: (selected) => setState(() => _filter = selected),
                ),
              ),
              LetterGridSection(letters: filtered),
              SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      }
    );
  }
}