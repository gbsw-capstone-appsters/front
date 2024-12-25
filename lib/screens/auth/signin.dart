import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:munhaedal/screens/quiz/quiz_start.dart';
import 'package:munhaedal/screens/auth/signup.dart';
import '../../widgets/Custom_btn.dart';
import '../../widgets/secure_textfield.dart';
import '../../widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sign() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.length < 6 || email.length > 60) {
      _showSnackBar('이메일은 6자 이상 60자 이하로 입력해주세요.');
      return;
    }

    final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegExp.hasMatch(email)) {
      _showSnackBar('이메일 형식이 올바르지 않습니다.');
      return;
    }

    if (password.length < 8 || password.length > 20) {
      _showSnackBar('비밀번호는 8~20자여야 합니다.');
      return;
    }
    if (password.contains(' ')) {
      _showSnackBar('비밀번호에 공백이 포함될 수 없습니다.');
      return;
    }

    setState(() => _isLoading = true);

    const String url = 'http://172.16.1.108/auth/signin';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['accessToken'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', responseData['accessToken']);
        }

        if (responseData['message'] != null) {
          _showSnackBar(responseData['message']);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizStart()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar('Error: ${errorData['message'] ?? '로그인 실패'}');
      }
    } catch (e) {
      _showSnackBar('네트워크 오류가 발생했습니다: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90.h,
                  ),
                  Image.network(
                    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Animals/Otter.png',
                    width: 180.w,
                    height: 180.h,
                  ),
                  Text(
                    '문해달',
                    style: TextStyle(
                      fontFamily: 'Regular',
                      color: const Color(0xff648DFC),
                      fontSize: 50.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    textfield_name: '이메일',
                  ),
                  SizedBox(height: 20.h),
                  SecureTextField(
                    controller: _passwordController,
                    textfield_name: '비밀번호',
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(text: '로그인', onPressed: _sign),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text(
                      '계정이 없나요?',
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Regular',
                          fontSize: 18.sp
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
