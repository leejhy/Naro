import 'package:flutter/material.dart';
import 'package:naro/widgets/common/select_date_dialog.dart';
import 'package:naro/widgets/common/image_upload.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/services/letter_notifier.dart';
import 'package:naro/controllers/image_upload_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:naro/utils/ad_manager.dart';
import 'package:naro/services/firebase_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/utils/utils.dart';

class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  final ImageUploadController imageController = ImageUploadController();
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode _blankFocus = FocusNode();
  late final FirebaseAnalytics analytics;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    analytics = ref.read(firebaseAnalyticsProvider);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dialogShown) {
      final route = ModalRoute.of(context);
      final animation = route is PageRoute ? route.animation : null;

      if (animation != null) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed && !_dialogShown) {
            _dialogShown = true;
            _showDateDialog(initial: true);
          }
        });
      } else {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDateDialog(initial: true);
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    _arrivalDateController.dispose();
    _blankFocus.dispose();
    super.dispose();
  }
  void _showDateDialog({bool initial = false}) {
    final navigator = Navigator.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: SelectDateDialog(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _arrivalDateController.text = pickedDate.toString();
        });
      } else if (initial){
        navigator.pop();
      }
    });
  }
  Future<String> saveImageToLocal(XFile image, int idx) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'Naro_${DateTime.now().millisecondsSinceEpoch.toString()}_$idx';
    await File(image.path).copy('${appDir.path}/$fileName.jpg');
    return '$fileName.jpg';
  }

  Future<int> insertLetter() async {
    final images = imageController.images;
    final savedPaths = await Future.wait(
      images.asMap().entries.map((entry) {
        final idx = entry.key;
        final img = entry.value;
        return saveImageToLocal(img, idx);
      }).toList()
    );
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Map<String, Object> letter = {
      'user_id': 1,
      'title': titleController.text,
      'content': contentController.text,
      'arrival_at': _arrivalDateController.text,
      'created_at': now ,
    };
    final id = await ref.read(letterNotifierProvider.notifier).addLetter(letter, savedPaths);
    final username = await DatabaseHelper.getUserName();
    analytics.logEvent(name: 'writing_confirm', parameters: {
      'username': username,
      'letter_id': id,
    });
    return id;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        surfaceTintColor: Color(0xffffffff),
        elevation: 1,
        shadowColor: const Color.fromARGB(50, 0, 0, 0),
        title: GestureDetector(
          onTap: () {
            analytics.logEvent(name: 'select_date_writing');
            _showDateDialog();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '도착: ${_arrivalDateController.text}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_month_rounded, size: 22),
            ],
          ),
        ),
      ),
      body: WritingBody(
        titleController: titleController,
        contentController: contentController,
        imageController: imageController,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              if (titleController.text.isEmpty || contentController.text.isEmpty) {
                showAutoDismissDialog(context, '제목과 내용을 입력해주세요');
                return;
              }
              FocusScope.of(context).requestFocus(_blankFocus);
              showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  insertLetter: insertLetter,
                  ads: AdManager.instance.rewardedAd,
                ),
              );
            },
            child: const Icon(Icons.check, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

class TextWriting extends StatefulWidget {
  const TextWriting({
    required this.titleController,
    required this.contentController,
    super.key
    });
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  State<TextWriting> createState() => _TextWritingState();
}

class _TextWritingState extends State<TextWriting> {
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  @override
  void dispose() {
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _toggleFocus(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();
    } else {
      node.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.titleController,
              maxLength: 40,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                counterText: '',
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF797979),
                ),
                border: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 400,
              child: TextField(
                controller: widget.contentController,
                focusNode: _contentFocus,
                onTap: () => _toggleFocus(_contentFocus),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16
                ),
                maxLength: 2000,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '본문을 작성하세요...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF797979),
                  ),
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


class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.insertLetter,
    required this.ads,
  });

  final Future<int> Function() insertLetter;
  final RewardedAd? ads;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      title: const Text('저장하시겠습니까?'),
      content: const Text('광고가 끝난 후 편지가 저장됩니다.', 
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Color(0xFF444444),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('취소', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          )),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            final id = await insertLetter();
            
            if (ads == null) {
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/result/$id');
              }
              return ;
            }
            ads!.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/result/$id');
              }
              },
            );
          },
          child: const Text('저장', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          )),
        ),
      ],
    );
  }
}

class WritingBody extends StatelessWidget {
  const WritingBody({
      required this.titleController,
      required this.contentController,
      required this.imageController,
      super.key
    });
  final TextEditingController titleController;
  final TextEditingController contentController;
  final ImageUploadController imageController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextWriting(
            titleController: titleController,
            contentController: contentController,
          ),
          ImageUpload(
            imageController: imageController,
          ),
          const SizedBox(height: 40),
        ],
      )
    );
  }
}
