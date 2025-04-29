import 'package:flutter/material.dart';
import 'package:naro/styles/text_styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.arrivalDate,
    required this.dDay,
    required this.letterCount,
  });
  final int letterCount;
  final DateTime arrivalDate;
  final int dDay;
  //음수 무시
  //dDay > 0 : dday, dday + 1일
  //dDay == 0 : dday, dday 음수 무시
  //todo 조건부 렌더링 dDay < 0이면 준비된 멘트중 1개로 대체 
  @override
  Widget build(BuildContext context) {
    print('header_section dday : $dDay');
    // todo dday 널처리
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 135,
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //todo dday 널처리(조건부 렌더링)
              //todo D-DAY 일때 도착멘트도 넣기
              if (dDay > 0) ... [
                Text('다가오는 편지', style: AppTextStyles.headingStyle),
                SizedBox(height: 2),
                Text('D-$dDay', style: AppTextStyles.dDayStyle),
                SizedBox(height: 2),
                Text('${arrivalDate.year}년 '
                '${arrivalDate.month}월 '
                '${arrivalDate.day}일 도착 예정', style: AppTextStyles.dateStyle),
              ] else if (dDay == 0)... [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '오늘 도착 편지',
                      style: AppTextStyles.arrivalStyle,
                    ),
                  ),
                ),
              ] else ... [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '오늘도 아니고 올 편지도 편지 없음',
                      style: AppTextStyles.arrivalStyle,
                    ),
                  ),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '오늘도 아니고 올 편지도 편지 없음',
                      style: AppTextStyles.arrivalStyle,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}