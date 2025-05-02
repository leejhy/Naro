import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/services/letter_notifier.dart';
import 'package:naro/utils.dart';
import 'package:naro/widgets/home/header_section.dart';
import 'package:naro/widgets/home/letter_view/letter_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff), //background
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeAppBar(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F7FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment(0, 0.5),
          ),
        ),
        child: HomeBody(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              context.push('/writing');
            },
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ]          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Naro', style: TextStyle(
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              //자간
            )),
            IconButton(
              onPressed: () {
                context.push('/setting');
                // DatabaseHelper.deleteAllLetter();
                print('appbar test');
              },
              icon: Icon(Icons.settings, size: 24)
            ),
          ]
        ),
      ),
    );
  }
}

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key,});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}
enum LetterFilter { all, arrived, inTransit }

class _HomeBodyState extends ConsumerState<HomeBody> {
  LetterFilter _filter = LetterFilter.all;

  @override
  Widget build(BuildContext context) {
    //todo modularization
    final letters = ref.watch(letterNotifierProvider);

    return letters.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
      data: (letters) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final upcoming = letters
          .map((i) => DateTime.parse(i['arrival_at'] as String))
          .where((dt) => !dt.isBefore(today))
          .toList();
        upcoming.sort((a, b) => a.compareTo(b));

        final nextDate = upcoming.isNotEmpty ? upcoming.first : DateTime(1900,1,1);
        final int dDay = calculateDday(nextDate);
        List<Map<String, dynamic>> filtered = switch (_filter) {
          LetterFilter.arrived =>
            letters.where((m) =>
              DateTime.parse(m['arrival_at']).isBefore(now) ||
              DateTime.parse(m['arrival_at']).isAtSameMomentAs(now)
            ).toList(),
          LetterFilter.inTransit =>
            letters.where((m) =>
              DateTime.parse(m['arrival_at']).isAfter(now)
            ).toList(),
          _ => letters
        };
        return CustomScrollView(
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
            LetterGrid (letters: filtered),
            SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      }
    );
    // print('home: in build $letters');
  }
}

class LetterSortingButtons extends StatelessWidget {
  const LetterSortingButtons({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final LetterFilter current;
  final ValueChanged<LetterFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SortingButton(
            label: '전체',
            selected: current == LetterFilter.all,
            onTap: () => onChanged(LetterFilter.all),
          ),
          const SizedBox(width: 8),
          SortingButton(
            label: '도착',
            selected: current == LetterFilter.arrived,
            onTap: () => onChanged(LetterFilter.arrived),
          ),
          const SizedBox(width: 8),
          SortingButton(
            label: '배송중',
            selected: current == LetterFilter.inTransit,
            onTap: () => onChanged(LetterFilter.inTransit),
          ),
        ],
      ),
    );
  }
}

class SortingButton extends StatelessWidget {
  const SortingButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        overlayColor: Color(0xFF00B6FF),
        minimumSize: const Size(4, 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: selected ? Colors.black : Colors.white,
        side: BorderSide(
          color: selected ? Colors.black : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}