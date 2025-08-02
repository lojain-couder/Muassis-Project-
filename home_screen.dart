import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:gg/api_service.dart'; // استيراد ملف الـ API

// دالة لعرض النافذة المنبثقة - الآن تأخذ النصيحة كمعامل
void showCustomPopup(BuildContext context, StudentAdvice? advice, bool isLoading, String? error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // تمرير النصيحة مباشرة إلى CustomPopup
      return CustomPopup(
        advice: advice,
        isLoading: isLoading,
        error: error,
      );
    },
  );
}

// الويدجت الذي يمثل تصميم النافذة بالكامل
// العودة إلى StatelessWidget لأنها لم تعد تجلب النصيحة بنفسها
class CustomPopup extends StatelessWidget {
  final StudentAdvice? advice;
  final bool isLoading;
  final String? error;

  const CustomPopup({
    super.key,
    required this.advice,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center, // Align items in the stack
        children: [
          // زر إغلاق البوب أب عند الضغط بالخارج
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.transparent,
            ),
          ),

          // البوكس في المنتصف مع المحتوى
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: screenSize.width * 0.8,
                  // Adjusted padding to account for the image being outside
                  padding: const EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 24), // Increased bottom padding
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 239, 228),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // عرض المحتوى بناءً على حالة النصيحة
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (error != null)
                        Text(
                          'خطأ في جلب النصيحة: $error',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )
                      else if (advice != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'مرحباً نورة', // أو استخدم advice.student['student_name']
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              advice!.advice, // عرض النصيحة التي تم تمريرها
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'لا توجد نصيحة متاحة.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      // Removed the image from here
                    ],
                  ),
                ),
              ),
            ),
          ),
          // الصورة بالأسفل
          
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final double savedAmount;
  final double goalAmount;
  // إضافة متغيرات لاستقبال النصيحة وحالتها
  final StudentAdvice? cachedAdvice;
  final bool isLoadingAdvice;
  final String? adviceError;

  const HomeScreen({
    super.key,
    required this.savedAmount,
    required this.goalAmount,
    required this.cachedAdvice, // استلام النصيحة
    required this.isLoadingAdvice,
    required this.adviceError,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 239, 228),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 65),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'حسابي',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 22, 42, 55),
                            ),
                          ),
                          const Text(
                            'مرحبًا نورة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 22, 42, 55),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/عملة.png', width: 70, height: 70),
                              Text(
                                '${(savedAmount + 321).toStringAsFixed(0)} ريال',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 22, 42, 55),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showCustomPopup(
                        context,
                        cachedAdvice, // تمرير النصيحة المخزنة
                        isLoadingAdvice, // تمرير حالة التحميل
                        adviceError, // تمرير أي أخطاء
                      ),
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/muasis2.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                // الهدف الحالي
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD18B5F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'هدف الادخار الحالي: المركز الصيفي',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD18B5F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 16),
                            LinearPercentIndicator(
                              animation: true,
                              animationDuration: 800,
                              lineHeight: 12.0,
                              percent: goalAmount > 0 ? (savedAmount / goalAmount).clamp(0.0, 1.0) : 0.0,
                              backgroundColor: Colors.grey,
                              progressColor: const Color(0xFFD18B5F),
                              barRadius: const Radius.circular(10),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ريال ${savedAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFD18B5F)),
                                ),
                                Text(
                                  '${goalAmount.toStringAsFixed(0)} ريال',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0x1AD18B5F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time, size: 18, color: Color(0xFFD18B5F)),
                                  SizedBox(width: 6),
                                  Text(
                                    'الوقت المتوقع: 3 أسابيع',
                                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // مستطيل النسب
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 4, right: 13),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'وين وصلتي في المصروفات هذا الشهر',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  CategoryIconCircle(icon: Icons.savings, percentage: 0.8, color: Color(0xFFD18B5F), size: 45),
                                  CategoryIconCircle(icon: Icons.school, percentage: 0.6, color: Color(0xFFD18B5F), size: 45),
                                  CategoryIconCircle(icon: Icons.celebration, percentage: 0.4, color: Color(0xFFD18B5F), size: 45),
                                  CategoryIconCircle(icon: Icons.fastfood, percentage: 0.8, color: Color(0xFFD18B5F), size: 45),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/WhatsApp Image 2025-07-28 at 5.53.36 PM.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // بطاقة الإحصائيات القابلة للنقل
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D253F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color.fromARGB(255, 22, 42, 55)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          StatColumn(icon: Icons.star, value: '15,420', label: 'النقاط', color: Color(0xFFD18B5F)),
                          StatColumn(icon: Icons.show_chart, value: '42', label: 'المستوى', color: Color(0xFFD18B5F)),
                          StatColumn(icon: Icons.emoji_events, value: '#7', label: 'من 1234', color: Color(0xFFD18B5F)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... بقية الكلاسات المساعدة كما هي (CategoryIconCircle, StatColumn)

class CategoryIconCircle extends StatelessWidget {
  final IconData icon;
  final double percentage;
  final Color color;
  final double size;

  const CategoryIconCircle({super.key, required this.icon, required this.percentage, required this.color, this.size = 70});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: percentage,
            strokeWidth: 5,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Icon(icon, size: size * 0.5, color: color),
      ],
    );
  }
}

class StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatColumn({super.key, required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}