import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:munhaedal/screens/auth/signin.dart';
import 'package:munhaedal/widgets/Custom_btn.dart';
import '../../widgets/secure_textfield.dart';
import '../../widgets/textfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signup() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String name = _nameController.text.trim();
    final String age = _ageController.text.trim();

    setState(() {
      _isLoading = true;
    });

    const String url = 'http://172.16.1.108/auth/signup';

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'nickName': name,
            'age': age,
          }));

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입이 성공적으로 완료되었습니다.')),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${errorData['message'] ?? '회원가입 실패'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _emailController,
                textfield_name: '이메일',
              ),
              SizedBox(
                height: 30,
              ),
              SecureTextField(
                controller: _passwordController,
                textfield_name: '비밀번호',
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _nameController,
                textfield_name: '이름',
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _ageController,
                textfield_name: '나이',
              ),
              SizedBox(height: 30),
              CustomButton(text: '회원가입', onPressed: _signup)
            ],
          ),
        ),
      ),
    );
  }
}
