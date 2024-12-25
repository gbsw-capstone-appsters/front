import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/signin.dart';

class QuizContent extends StatefulWidget {
  const QuizContent({super.key});

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  String passage = "지문을 불러오는 중...";
  final int userId = 1;
  final String category = "사자성어";

  Future<void> Quiz() async {
    const String url = 'http://172.16.1.108/quiz/start';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          passage = responseData['passage'];
        });
      } else {
        final responseData = jsonDecode(response.body);
        setState(() {
          passage = responseData['passage'] ?? "퀴즈를 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        passage = "네트워크 오류가 발생했습니다: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Quiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            passage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}