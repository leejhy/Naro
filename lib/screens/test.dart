import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/services.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlyingLetter();
  }
}

class FlyingLetter extends StatefulWidget {
  const FlyingLetter({super.key, this.onCompleted});
  final VoidCallback? onCompleted;

  @override
  State<FlyingLetter> createState() => _FlyingLetterState();
}

class _FlyingLetterState extends State<FlyingLetter> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  // 편지 애니메이션
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  // 파티클 효과용 랜덤 생성기
  final Random _random = math.Random();
  
  // 파티클 리스트
  final List<Particle> _particles = [];
  final int _particleCount = 15;
  
  // 편지 상태
  bool _isResting = true;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();

    // 메인 애니메이션 컨트롤러
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isResting = true;
          _showParticles = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
    // 맥박 효과 컨트롤러 (대기 상태에서 미세하게 움직임)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // 파티클 효과 컨트롤러
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 베지어 곡선을 사용한 자연스러운 경로 애니메이션
    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.2, -0.5),
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.2, -0.5),
          end: const Offset(0.8, -0.8),
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.8, -0.8),
          end: const Offset(1.5, -1.2),
        ).chain(CurveTween(curve: Curves.easeInQuint)),
        weight: 30,
      ),
    ]).animate(_mainController);

    // 투명도 애니메이션 (끝에서 점점 투명하게)
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_mainController);

    // 회전 애니메이션 (자연스러운 회전)
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.1)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: -0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: math.pi * 0.3)
            .chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 50,
      ),
    ]).animate(_mainController);

    // 크기 애니메이션 (처음에 약간 커졌다가 날아가면서 작아짐)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.4)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 60,
      ),
    ]).animate(_mainController);
    
    // 그림자 높이 애니메이션
    _elevationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 15.0)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 15.0, end: 5.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_mainController);
    
    // 파티클 초기화
    _initializeParticles();
  }
  
  void _initializeParticles() {
    _particles.clear();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        position: Offset.zero,
        velocity: Offset(
          (_random.nextDouble() * 2 - 1) * 1.5,
          (_random.nextDouble() * -1.5) - 0.5,
        ),
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 3,
        lifespan: _random.nextDouble() * 0.7 + 0.3,
      ));
    }
  }
  
  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.redAccent.withOpacity(0.8),
      Colors.pinkAccent.withOpacity(0.8),
      Colors.purpleAccent.withOpacity(0.8),
      Colors.orangeAccent.withOpacity(0.8),
      Colors.amberAccent.withOpacity(0.8),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void startAnimation() {
    HapticFeedback.mediumImpact(); // 햅틱 피드백 추가
    
    setState(() {
      _isResting = false;
      _showParticles = true;
    });
    
    _initializeParticles();//?
    _mainController.reset();
    _mainController.forward();
    _particleController.reset();
    _particleController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Flying Letter", 
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 그라데이션
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey.shade100],
              ),
            ),
          ),
          
          // 파티클 효과
          if (_showParticles)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    progress: _particleController.value,
                  ),
                );
              },
            ),
          
          // 메인 편지 애니메이션
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_mainController, _pulseController]),
              builder: (context, child) {
                return SlideTransition(
                  position: _positionAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value + 
                          (_isResting ? math.sin(_pulseController.value * math.pi) * 0.05 : 0),
                      child: Transform.scale(
                        scale: _scaleAnimation.value * 
                            (_isResting ? 1.0 + _pulseController.value * 0.05 : 1.0),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Material(
                elevation: _isResting ? 4 : _elevationAnimation.value,
                shadowColor: Colors.black38,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 84,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // 편지 봉투 디자인
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomPaint(
                          size: const Size(84, 62),
                          painter: EnvelopePainter(),
                        ),
                      ),
                      // 하트 아이콘
                      // Center(
                      //   child: Icon(
                      //     Icons.favorite,
                      //     size: 18,
                      //     color: Colors.redAccent.withOpacity(0.8),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 버튼
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(30),
                color: Colors.redAccent,
                child: InkWell(
                  onTap: _isResting ? startAnimation : null,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.send, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "편지 날리기",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 파티클 클래스
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifespan; // 0.0 ~ 1.0

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifespan,
  });
}

// 파티클 페인터
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // 파티클 위치 계산
      final x = size.width / 2 + particle.velocity.dx * progress * size.width * 0.5;
      final y = size.height / 2 + 
          (particle.velocity.dy * progress * size.height * 0.5) + 
          (2.0 * progress * progress * size.height * 0.3); // 중력 효과
      
      // 파티클 크기와 투명도 계산 (시간에 따라 감소)
      final particleProgress = math.min(1.0, progress / particle.lifespan);
      final opacity = math.max(0.0, 1.0 - particleProgress);
      final currentSize = particle.size * (1.0 - particleProgress * 0.5);
      
      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// 편지 봉투 디자인 페인터
class EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();

    final w = size.width;
    final h = size.height;

    path.moveTo(0, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    canvas.drawPath(path, paint);

    final middleX = w / 2;
    final middleY = h / 2;

    // 3. 선 그리기용 paint
    final linePaint = Paint()
      ..color = Color(0xFFABCEDC)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round  // 연결부를 둥글게 처리
      ..style = PaintingStyle.stroke;   // 선 스타일로 그리기

    // 원래 개별로 그리던 두 선을 하나의 Path로 합침으로써 연결부 적용
    final topFlapPath = Path();
    topFlapPath.moveTo(0, 0);
    topFlapPath.lineTo(middleX, middleY + 6);
    topFlapPath.lineTo(w, 0);
    canvas.drawPath(topFlapPath, linePaint);
  
    final cutOffset = 10;
    final leftEdge = Offset(middleX - cutOffset, middleY - 1);
    final rightEdge = Offset(middleX + cutOffset, middleY - 1);

    canvas.drawLine(Offset(0, h), leftEdge, linePaint);
    canvas.drawLine(Offset(w, h), rightEdge, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
