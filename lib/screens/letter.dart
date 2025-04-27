import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/services/database_helper.dart';

// todo:
// 1. implement letter screen view
class LetterScreen extends StatefulWidget {
  final String letterId;
  const LetterScreen({
    super.key,
    required this.letterId
  });

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  List<Map<String, Object?>>? _letter;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  // List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadLetter();
    //todo letterId null 체크
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    debugPrint('letterㅁㄴㅇId: ${widget.letterId}');
  }
  Future<void> _loadLetter() async {
    final data = await DatabaseHelper.getLetter(int.parse(widget.letterId));
    if (data.isNotEmpty) {
      final row = data.first;
      _titleController.text = row['title'] as String? ?? '';
      _contentController.text = row['content'] as String? ?? '';
      // final photoPath = row['photo_path'] as String?;
      // if (photoPath != null && photoPath.isNotEmpty) {
      //   _imagePaths = [photoPath];
      // }
    }
    setState(() => _letter = data);
  }

  @override
  Widget build(BuildContext context) {
    if (_letter == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final letterRow = _letter!.first;
    debugPrint('letterRow: $letterRow');
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
          TextWriting(
            title: _titleController.text,
            content: _contentController.text,
          ),
          PhotoUpload(),
        ],
      ),
    );
  }
}

class TextWriting extends StatelessWidget {
  final String title;
  final String content;
  const TextWriting({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 10),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                ),
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
                onTap: () => context.push('/test'),
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