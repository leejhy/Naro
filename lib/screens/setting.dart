import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naro/services/database_helper.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  // 모달 시트 표시 함수
void showDialog(context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFCAEBF7),Colors.white],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        // ⬇️ 여기만 패딩 주기 (시트 높이는 그대로 유지)
        child: Stack(
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.close_rounded),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '문의하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: '문의 내용을 입력하세요',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: bottomInset,
              right: MediaQuery.of(context).size.width * 0.24,
              left: MediaQuery.of(context).size.width * 0.24,
                child: SizedBox(
                  height: 56,
                  child: FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: const Color(0xFFCAEBF7),
                    child: const Text(
                      '전송',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('문의하기'),
            onTap: () => showDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 정보'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('개인정보 처리방침'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}


    Future<void> onTap(String message) async {
      final feedback = {
        'username': await DatabaseHelper.getUserName(),
        'content': message,
        'createdAt': DateTime.now(),
      };
      final db = FirebaseFirestore.instance;
      await db.collection('feedback').add(feedback);
    }