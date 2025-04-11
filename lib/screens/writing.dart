import 'package:flutter/material.dart';

class WritingScreen extends StatelessWidget {
  const WritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        surfaceTintColor: Color(0xffffffff),
        elevation: 1,
        shadowColor: Colors.black,
        title: const Text('2024-01-01, 금요일', style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NotionStyleEditor(),
        ],
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
            print('test');
          },
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}


class NotionStyleEditor extends StatelessWidget {
  const NotionStyleEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력창
            TextField(
              maxLength: 40,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                counterText: '',
                hintText: '제목을 입력하세요',
                border: InputBorder.none,
              ),
            ),
            SizedBox(//SizedBox
              // color: Colors.amber,
              height: 400,
              // decoration: BoxDecoration(
              //   border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              // ),
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),
                maxLength: 2000,
                expands: true,// expands: true일때 maxLines: null 필수
                maxLines: null, //무한 Lines
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '본문을 작성하세요...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1, color: Colors.grey.shade300),
            SizedBox(height: 10),
            Text('사진', style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
    );
  }
}
