import 'package:flutter/material.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/common/app_bar.dart';
import 'package:naro/widgets/letter/text_writing.dart';
import 'package:naro/widgets/letter/image_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';

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
  Map<String, Object?>? _letter;
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

    setState(() => _letter = data.first);
  }
  @override
  Widget build(BuildContext context) {
    if (_letter == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final String date = _letter?['arrival_at'] as String? ?? '';
    String formattedDate = '';
    final parsed = DateTime.tryParse(date);
    if (parsed != null) {
      final locale = context.locale.toLanguageTag();
      final weekday = DateFormat.EEEE(locale).format(parsed);
      final datePart = DateFormat.yMMMMd(locale).format(parsed);

      formattedDate = locale.startsWith('ko')
                    ? '$datePart $weekday'
                    : '$weekday, $datePart';
    } else {
      formattedDate = date;
    }
    return Scaffold(
      backgroundColor: UIColors.backgroundGray,
      appBar: TitleAppBar(title: formattedDate),
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
