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
          TextWriting(),
          PhotoUpload(),
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
            showDialog(
              context: context,
              builder: (context) => const ConfirmDialog(),
            );
            print('test');
          },
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class TextWriting extends StatelessWidget {
  const TextWriting({super.key});

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
            Divider(thickness: 1, color: Colors.grey.shade300),
          ],
        ),
    );
  }
}

class PhotoUpload extends StatelessWidget {
  const PhotoUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('사진', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          Row(
            children: [
              GestureDetector(
                onTap: () => print('photo button'),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 167, 167, 167),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade500)
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                )
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => print('photo button2'),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 167, 167, 167),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade500)
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                )
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('저장하시겠습니까?'),
      content: const Text('저장 후에는 수정할 수 없습니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}