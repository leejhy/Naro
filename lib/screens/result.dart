import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/utils/utils.dart';
import 'package:naro/widgets/result/flying_letter.dart';
import 'package:naro/services/letter_notifier.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final String letterId;
  const ResultScreen({
    super.key,
    required this.letterId
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> with SingleTickerProviderStateMixin {
  bool _showFlyingLetter = true;
  late final AnimationController _textController;
  late final Animation<double> _fade1, _fade2, _fade3, _fade4;
  late final Animation<Offset> _slide1, _slide2, _slide3, _slide4;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fade1  = CurvedAnimation(parent: _textController, curve: const Interval(0.00, 0.25, curve: Curves.easeOut));
    _fade2  = CurvedAnimation(parent: _textController, curve: const Interval(0.15, 0.40, curve: Curves.easeOut));
    _fade3  = CurvedAnimation(parent: _textController, curve: const Interval(0.35, 0.55, curve: Curves.easeOut));
    _fade4  = CurvedAnimation(parent: _textController, curve: const Interval(0.45, 0.70, curve: Curves.easeOut));

    _slide1 = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(_fade1);
    _slide2 = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(_fade2);
    _slide3 = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(_fade3);
    _slide4 = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(_fade4);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(letterNotifierProvider);

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCAEBF7), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showFlyingLetter ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            child: _buildResultContent(),
          ),
          if (_showFlyingLetter)
            FlyingLetter(
              onCompleted: () {
                setState(() => _showFlyingLetter = false );
                _textController.forward(from: 0.0);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    final int letterId = int.parse(widget.letterId);
    final String? arrivalDate =
        ref.read(letterNotifierProvider.notifier).getLetterArrivalDate(letterId);
    final dDay =
        arrivalDate != null ? calculateDday(DateTime.parse(arrivalDate)) : -1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCAEBF7), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment(0, 0.55),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),

              FadeTransition(
                opacity: _fade1,
                child: SlideTransition(
                  position: _slide1,
                  child: Icon(Icons.mark_email_read_outlined,
                      size: 64, color: Color(0xFF4A90E2)),
                ),
              ),

              const SizedBox(height: 16),

              FadeTransition(
                opacity: _fade2,
                child: SlideTransition(
                  position: _slide2,
                  child: const Text('도착일',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54)),
                ),
              ),

              const SizedBox(height: 4),

              FadeTransition(
                opacity: _fade3,
                child: SlideTransition(
                  position: _slide3,
                  child: Column(
                    children: [
                      Text(arrivalDate ?? '',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 26,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('D-$dDay', style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A90E2))),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: _fade4,
                child: SlideTransition(
                  position: _slide4,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '이 편지를 읽을 순간이,\n벌써부터 궁금하고 기대돼요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueGrey),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: const Color.fromRGBO(69, 90, 100, 1),
                    ),
                    child: const Text('나의 시간으로 돌아가기', style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 90, 100, 1),
                      fontSize: 18
                    )),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}