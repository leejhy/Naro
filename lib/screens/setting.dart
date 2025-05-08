import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/utils/utils.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  // 모달 시트 표시 함수
  void showDialog(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const ContactModal(),
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
            title: const Text('의견 보내기'),
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

class ContactModal extends StatefulWidget {
  const ContactModal({super.key});

  @override
  State<ContactModal> createState() => _ContactModalState();
}

class _ContactModalState extends State<ContactModal> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 24).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Widget inputTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  Widget settingTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    required int maxLength,
    }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.normal,
        fontSize: 16
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
  Future<void> submitFeedback(String contact, String message) async {
    final now = DateTime.now().toUtc();
    final formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
    final feedback = {
      'contact': contact,
      'content': message,
      'createdAt': formattedDate,
    };
    await FirebaseFirestore.instance.collection('feedback').add(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
      child: Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(left: 8),
                      onPressed: () {},
                      icon: Icon(Icons.close_rounded),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: const Text(
                              '의견 보내기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          inputTitle('contact'),
                          const SizedBox(height: 8),
                          settingTextField(
                            controller: _emailController,
                            hintText: 'example@email.com',
                            maxLines: 1,
                            maxLength: 40,
                          ),
                          const SizedBox(height: 16),
                          inputTitle('message'),
                          const SizedBox(height: 8),
                          settingTextField(
                            controller: _messageController,
                            hintText: '피드백, 버그, 제안 등',
                            maxLines: 10,
                            maxLength: 300,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
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
                  onPressed: () async {
                    final contact = _emailController.text.trim();
                    final message = _messageController.text.trim();

                    if (contact.isEmpty || message.isEmpty) {
                      showAutoDismissDialog(context, '모든 항목을 입력해주세요.');
                      return ;
                    }
                    await submitFeedback(contact, message);
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        Future.delayed(const Duration(milliseconds: 1200), () {
                          Navigator.of(context).pop(); // 닫기
                          Navigator.of(context).pop(); // 모달 닫기
                        });
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xFF4A90E2),
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '의견이 전송되었습니다!',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  // onPressed: () {
                  //   submitFeedback(_emailController.text, _messageController.text);
                  //   debugPrint('contact: ${_emailController.text}');
                  //   debugPrint('message: ${_messageController.text}');
                  // },
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
  }
}
