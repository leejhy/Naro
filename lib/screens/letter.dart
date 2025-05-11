import 'package:flutter/material.dart';
import 'package:naro/services/database_helper.dart';
import 'dart:io';
import 'package:naro/widgets/common/image_viewer.dart';

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
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  
    _loadLetter();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadLetter() async {
    final letterId = int.parse(widget.letterId);
    final data = await DatabaseHelper.getLetter(letterId);
    final imagepath = await DatabaseHelper.getImagePaths(letterId);

    if (!mounted) return ;
    if (data.isNotEmpty) {
      final row = data.first;
      _titleController.text = row['title'] as String? ?? '';
      _contentController.text = row['content'] as String? ?? '';
    }

    if (imagepath.isNotEmpty) {
      _imagePaths = imagepath;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWriting(
              title: _titleController.text,
              content: _contentController.text,
            ),
            
            ImageGridView(
              imagePaths: _imagePaths,
            ),
          ],
        ),
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

class ImageGridView extends StatelessWidget {
  const ImageGridView({super.key, required this.imagePaths});
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('사진', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            children: List.generate(3, (index) {
              if (index < imagePaths.length) {
                return _buildPhotoItem(context, imagePaths[index]);
              }
              return Container();
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, String imagePath) {
    final file = File(imagePath);
    final exists = file.existsSync();
    if (!exists) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported_rounded, size: 30, color: Colors.white70),
        ),
      );
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ImageViewer(imagePath: imagePath),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.fill,
              ),
            ),
          )
        ),
      ],
    );
  }
}