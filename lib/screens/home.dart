import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/widgets/home/letter_view/letter_grid.dart';
import 'package:sqflite/sqflite.dart';

//todo
// View
// 1. Complete sorting button implementation
// 2. Implement letter card UI
// 3. Fix timestamp display issue on letter cards

// Logic
// 1. Add null-check logic and fallback placeholders
// 2. Implement D-Day calculation logic for arrival date - ok

final headingStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.5,
);

final dDayStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 30,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
);

final dateStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  letterSpacing: -0.1,
  color: Color(0xff6B7280),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> letters = [];

  @override
  void initState() {
    super.initState();
    _loadLetters();  // 비동기 함수 호출
  }

  Future<void> _loadLetters() async {
    final value = await DatabaseHelper.getAllLetters();
    setState(() {
      letters = value;
    });
    print('letters $letters');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff), //background
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeAppBar(),
      ),
      body: Container(
        color: const Color(0xffF9FAFB),
        child: HomeBody(
          letters: letters,
        )
      ),
      floatingActionButton: SizedBox(
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
        // color: Colors.amber,
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
                print('appbar test');
              },
              icon: Icon(Icons.settings, size: 24)),
          ]
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
    required this.letters,
    });
  final List<Map<String,dynamic>> letters;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  @override
  Widget build(BuildContext context) {
    final letters = widget.letters;
    print('in build $letters');
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 20)
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( '다가오는 편지', style: headingStyle),
                  SizedBox(height: 2),
                  Text('D-10', style: dDayStyle),
                  SizedBox(height: 2),
                  Text('2024년 1월 1일 도착 예정', style: dateStyle),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SortingButton(label: '전체'),
                  SizedBox(width: 8),
                  SortingButton(label: '도착'),
                  SizedBox(width: 8),
                  SortingButton(label: '배송중'),
                ],
              ),
            ),
          )
        ),
        LetterGrid(
          letters: letters,
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 40)
        ),
      ],
    );
  }
}

class _SortingButtonState extends State<SortingButton> {
  late bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = false;
  }

  void toggleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
    // widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, 0),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: isSelected ? Colors.black : Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Text(widget.label, style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      )),
      onPressed: () async {
        final letters = await DatabaseHelper.getAllLetters();
        print('letters');
        print(letters);
        // print('SortingButton pressed');
        toggleSelected();
      },
    );
  }
}

class SortingButton extends StatefulWidget {
  final String label;
  final bool selected;

  const SortingButton({
    super.key,
    required this.label,
    this.selected = false,
  });

  @override
  State<SortingButton> createState() => _SortingButtonState();
}