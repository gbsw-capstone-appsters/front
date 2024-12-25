import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:munhaedal/screens/quiz/quiz_content.dart';

class QuizStart extends StatelessWidget {
  const QuizStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 120.h,
            ),
            Container(
              padding: EdgeInsets.only(right: 70),
              child: Text(
                '방금 내용의\n퀴즈를 풀어볼까요?',
                style: TextStyle(
                    fontSize: 30.sp,
                    fontFamily: 'Regular',
                    color: Color(0xff648DFC)),
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            Image.network(
              'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Face%20with%20Monocle.png',
              width: 150.w,
              height: 150.h,
            ),
            SizedBox(
              height: 80.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff648DFC),
                  minimumSize: Size(320, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizContent()));
              },
              child: Text(
                'start!',
                style: TextStyle(
                    fontSize: 30, color: Colors.white, fontFamily: 'Regular'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
