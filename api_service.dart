import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. نموذج البيانات لتمثيل استجابة الـ API
class StudentAdvice {
  final Map<String, dynamic> student;
  final String advice;

  StudentAdvice({required this.student, required this.advice});

  factory StudentAdvice.fromJson(Map<String, dynamic> json) {
    return StudentAdvice(
      student: json['student'] as Map<String, dynamic>,
      advice: json['advice'] as String,
    );
  }
}

// 2. دالة لجلب النصيحة من الـ API
Future<StudentAdvice> fetchAdvice() async {
  // *** هام: هذا الرابط يتغير في كل مرة تعيد تشغيل الـ Ngrok ***
  // تأكد من تحديثه بالرابط الجديد الذي يوفره لك Ngrok في الكونسول
  final response = await http.get(Uri.parse('https://02e574c53ba4.ngrok-free.app/advice')); // يرجى تحديث هذا الرابط

  if (response.statusCode == 200) {
    // إذا كانت الاستجابة 200 OK، قم بفك ترميز JSON.
    return StudentAdvice.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // إذا لم تكن الاستجابة 200، قم بإلقاء استثناء.
    throw Exception('Failed to load advice: ${response.statusCode}');
  }
}