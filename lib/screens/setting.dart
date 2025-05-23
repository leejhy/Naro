import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:naro/utils/utils.dart';
import 'package:naro/const.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

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
        title: Text(
          'settings.title'.tr(),
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
            title: Text('settings.send_feedback'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              showDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text('settings.privacy_policy'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              launchUrl(PRIVACY_URL_KR,
              mode: LaunchMode.inAppBrowserView);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text('settings.terms_of_service'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
               ),
              ),
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
            title: Text('settings.app_info'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              showTextDialog(
                context,
                'settings.app_version'.tr(),
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
                          child: Text(
                            'settings.contact_label'.tr(),
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
                          hintText: 'settings.message_hint'.tr(),
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
                      showAutoDismissDialog(context, 'settings.error_empty_input'.tr());
                      return ;
                    }
                    try {
                      await submitFeedback(contact, message);
                    } catch (e) {
                      showAutoDismissDialog(context, 'settings.error_generic'.tr());
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
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xFF4A90E2),
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'settings.success_feedback_sent'.tr(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  backgroundColor: const Color(0xFFE3F7FF),
                  child: Text(
                    'settings.submit_button'.tr(),
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
