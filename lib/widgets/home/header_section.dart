import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.arrivalDate,
    required this.dDay,
  });
  final DateTime arrivalDate;
  final int dDay;
  //todo 조건부 렌더링 dDay < 0이면 준비된 멘트중 1개로 대체 
  @override
  Widget build(BuildContext context) {
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
    //todo dday 널처리
    return SliverPadding(
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
              //todo dday 널처리(조건부 렌더링)
              //todo D-DAY 일때 도착멘트도 넣기 
              Text('다가오는 편지', style: headingStyle),
              SizedBox(height: 2),
              Text('D-DAY: $dDay', style: dDayStyle),
              SizedBox(height: 2),
              Text('${arrivalDate.year}년 '
              '${arrivalDate.month}월 '
              '${arrivalDate.day}일 도착 예정', style: dateStyle),
            ],
          ),
        ),
      ),
    );
  }
}