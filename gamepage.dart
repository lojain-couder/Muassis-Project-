import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // تأكد من إضافة الحزمة
import 'package:flutter/services.dart'; // استيراد لتغيير اتجاه الشاشة

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
    // تغيير اتجاه الشاشة إلى العرض (Landscape) عند الدخول على صفحة اللعبة
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
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

  @override
  void dispose() {
    // إعادة الشاشة إلى الوضع الطبيعي (Vertical) عند مغادرة الصفحة
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }
}
