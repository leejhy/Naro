import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          
          // 알림 설정
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('알림 설정'),
            trailing: Switch(
              value: true, // todo: 상태 연결
              onChanged: (value) {
                // TODO: 알림 설정 토글 로직
              },
            ),
          ),
          const Divider(),

          // 테마 설정
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('다크 모드'),
            trailing: Switch(
              value: false, // todo: 상태 연결
              onChanged: (value) {
                // TODO: 다크모드 토글 로직
              },
            ),
          ),
          const Divider(),

          // 앱 정보
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 정보'),
            onTap: () {
              // TODO: 앱 버전 다이얼로그 띄우기
            },
          ),
          const Divider(),

          // 문의하기
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('문의하기'),
            onTap: () {
              // TODO: 이메일 또는 외부 링크 연결
            },
          ),
          const Divider(),

          // 약관
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('이용약관 및 개인정보 처리방침'),
            onTap: () {
              // TODO: 약관 화면 띄우기
            },
          ),
        ],
      ),
    );
  }
}
