import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/widgets/common/date_dialog.dart';
import 'package:naro/widgets/common/photo_upload.dart';

//todo
//1. dialog for selecting arrival date - ok
//2. photo upload - 
//3. save button
//4. go_route to result screen

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});
  //부모위치에 textField controller를 두기

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dialogShown) {
      final route = ModalRoute.of(context);
      final animation = route is PageRoute ? route.animation : null;

      if (animation != null) {
        // 애니메이션 상태 변화를 듣는다
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed && !_dialogShown) {
            _dialogShown = true;
            _showDateDialog(initial: true);
          }
        });
      } else {
        // 애니메이션이 없으면 바로 띄우기
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDateDialog(initial: true);
        });
      }
    }
  }
  void _showDateDialog({bool initial = false}) {
    final navigator = Navigator.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200), // ← Fade 속도 설정
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: DateDialog(), // 여기에 커스텀 다이얼로그 위젯
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
          _dateController.text = pickedDate.toString();
        });
        print('Selected date: $pickedDate');
      } else if (initial){
        navigator.pop();
        print('No date selected');
      }
    });
  }
  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  void insertLetter() {
    final Map<String, Object> letter = {
      'user_id': 1,      
      'title': titleController.text,
      'content': contentController.text,
      'arrival_at': DateTime.now().add(Duration(days: 30)).toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    };
    DatabaseHelper.insertLetter(letter);
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
            print('title tap');
            _showDateDialog();
          },
          child: Text('도착: ${_dateController.text}', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
      body: Container(
        child: 
          WritingBody(
            titleController: titleController,
            contentController: contentController,
          ),
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
          },
          child: const Icon(Icons.check, color: Colors.white, size: 30),
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
  // 위 controller에 textField 값 저장됨 

  @override
  void dispose() {
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _toggleFocus(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();                     // 이미 열려 있으면 → 키보드 닫기
    } else {
      node.requestFocus();                // 안 열려 있으면 → 키보드 열기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력창
            TextField(
              controller: widget.titleController,
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
                controller: widget.contentController,
                focusNode: _contentFocus,
                onTap: () => _toggleFocus(_contentFocus),
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
            context.push('/test');
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class WritingBody extends StatelessWidget {
  const WritingBody({
      required this.titleController,
      required this.contentController,
      super.key
    });
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextWriting(
            titleController: titleController,
            contentController: contentController,
          ),
          PhotoUpload(),
          SizedBox(height: 40),
        ],
      )
    );
  }
}
