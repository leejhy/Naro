import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:naro/utils/utils.dart';
import 'package:naro/const.dart';
import 'package:flutter/services.dart';

//think about haptic feedback


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: UIColors.white,
        surfaceTintColor: UIColors.white,
        elevation: 2,
        shadowColor: UIColors.appbarShadow,
        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('의견 보내기'),
            onTap: () {
              HapticFeedback.lightImpact();
              showDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('개인정보 처리방침'),
            onTap: () {
              HapticFeedback.lightImpact();
              launchUrl(PRIVACY_URL_KR,
              mode: LaunchMode.inAppBrowserView);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('이용약관'),
            onTap: () {
              HapticFeedback.lightImpact();
              launchUrl(TERMS_URL_KR,
              mode: LaunchMode.inAppBrowserView
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('앱 정보'),
            onTap: () {
              HapticFeedback.lightImpact();
              showTextDialog(
                context,
                '앱정보: v1.0.0'
              );
            },
          ),
          const Divider(),
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


  @override
  void dispose() {
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
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: 16
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w300,
          color: Color(0xFF797979),
          fontSize: 16
        ),
        filled: true,
        fillColor: const Color.fromRGBO(255, 255, 255, 0.9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(191, 191, 191, 0.5)),
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
          colors: [Color(0xFFE3F7FF),Colors.white],
          begin: Alignment.topCenter,
          end: Alignment(0, 0.5),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: const EdgeInsets.only(left: 8),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          hintText: '피드백, 버그, 제안, 인사 등',
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
          Positioned(
            bottom: bottomInset,
            right: MediaQuery.of(context).size.width * 0.24,
            left: MediaQuery.of(context).size.width * 0.24,
              child: SizedBox(
                height: 56,
                child: FloatingActionButton(
                  onPressed: () async {
                    HapticFeedback.vibrate();
                    //todo add fireworks animation
                    final contact = _emailController.text.trim();
                    final message = _messageController.text.trim();
                    if (contact.isEmpty || message.isEmpty) {
                      showAutoDismissDialog(context, '모든 항목을 입력해주세요.');
                      return ;
                    }
                    try {
                      await submitFeedback(contact, message);
                    } catch (e) {
                      showAutoDismissDialog(context, '오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                      return;
                    }
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        Future.delayed(const Duration(milliseconds: 1200), () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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

                  backgroundColor: const Color(0xFFE3F7FF),
                  child: const Text(
                    '전송',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
