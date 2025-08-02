import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'savings_page.dart';
import 'package:gg/api_service.dart'; // استيراد ملف الـ API
import 'package:webview_flutter/webview_flutter.dart'; // تأكد من إضافة الحزمة

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  double savedAmount = 29.0;
  final double goalAmount = 541.0;
  int _currentIndex = 0;

  // إضافة متغير لتخزين النصيحة التي تم جلبها
  StudentAdvice? _cachedAdvice;
  bool _isLoadingAdvice = true;
  String? _adviceError;

  @override
  void initState() {
    super.initState();
    _fetchAndCacheAdvice(); // جلب النصيحة عند تهيئة الـ State
  }

  void _fetchAndCacheAdvice() async {
    try {
      final advice = await fetchAdvice(); // جلب النصيحة من الـ API
      setState(() {
        _cachedAdvice = advice;
        _isLoadingAdvice = false;
      });
    } catch (e) {
      setState(() {
        _adviceError = e.toString();
        _isLoadingAdvice = false;
      });
      print('Error fetching advice: $e'); // للتحقق من الأخطاء في الكونسول
    }
  }

  void _updateSavedAmount(double amountToAdd) {
    setState(() {
      savedAmount += amountToAdd;
    });
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الصفحات التي سيتم عرضها.
    // يتم تمرير قيم الادخار ودالة التحديث هنا
    final List<Widget> screens = [
      // الصفحة الأولى: الرئيسية
      HomeScreen(
        savedAmount: savedAmount,
        goalAmount: goalAmount,
        // تمرير النصيحة والخطأ وحالة التحميل إلى HomeScreen
        cachedAdvice: _cachedAdvice,
        isLoadingAdvice: _isLoadingAdvice,
        adviceError: _adviceError,
      ),
      // الصفحة الثانية: اللعبة
      GamePage(), // تم إضافة صفحة اللعبة هنا عبر WebView
      // الصفحة الثالثة: الادخار
      SavingsPage(
        savedAmount: savedAmount,
        goalAmount: goalAmount,
        onAddAmount: _updateSavedAmount,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex], // سيعرض الصفحة بناءً على الفهرس
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD18B5F),
        unselectedItemColor: const Color(0xFF2D253F),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'اللعبة'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'ادخر'),
        ],
      ),
    );
  }
}

// صفحة WebView لعرض اللعبة
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController(); // تهيئة WebViewController
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Unity Game'),
      ),
      body: WebViewWidget( // WebViewWidget لعرض اللعبة
        controller: _controller,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحميل الرابط باستخدام loadRequest
    _controller.loadRequest(Uri.parse('https://lojai.itch.io/muassis')); // استبدل هذا بالرابط الخاص باللعبة على itch.io
  }
}
