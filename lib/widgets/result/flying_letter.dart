import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/services.dart';

class FlyingLetter extends StatefulWidget {
  const FlyingLetter({
    super.key,
    required this.onCompleted,
    });
  final VoidCallback? onCompleted;

  @override
  State<FlyingLetter> createState() => _FlyingLetterState();
}

class _FlyingLetterState extends State<FlyingLetter> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  final Random _random = math.Random();
  
  final List<Particle> _particles = [];
  final int _particleCount = 15;
  
  bool _isResting = true;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();

        setState(() {
          _isResting = true;
          _showParticles = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

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
      Color.fromRGBO(255, 82, 82, 0.8),
      Color.fromRGBO(255, 64, 129, 0.8),
      Color.fromRGBO(224, 64, 251, 0.8),
      Color.fromRGBO(255, 171, 64, 0.8),
      Color.fromRGBO(255, 215, 64, 0.8),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void startAnimation() {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isResting = false;
      _showParticles = true;
    });
    
    _initializeParticles();
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCAEBF7),Colors.white],
              ),
            ),
          ),
          
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
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomPaint(
                          size: const Size(84, 62),
                          painter: EnvelopePainter(),
                        ),
                      ),
                    ],
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

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifespan;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifespan,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = size.width / 2 + particle.velocity.dx * progress * size.width * 0.5;
      final y = size.height / 2 + 
          (particle.velocity.dy * progress * size.height * 0.5) + 
          (2.0 * progress * progress * size.height * 0.3);
      
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

    final linePaint = Paint()
      ..color = Color(0xFFABCEDC)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

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
