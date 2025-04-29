import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// todo:4/24
// 1. Trigger animation when ResultScreen is opened for the first time
// 2. Add screen to display the arrival date, phrase

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
          child: Column(
            children: [
              const Text(
                'Result Screen',
                style: TextStyle(fontSize: 24),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/');
              },
            ),
            ],
          ),
        ),
    );
  }
}