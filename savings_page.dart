import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingsPage extends StatefulWidget {
  final double savedAmount;
  final double goalAmount;
  final Function(double) onAddAmount;

  const SavingsPage({
    super.key,
    required this.savedAmount,
    required this.goalAmount,
    required this.onAddAmount,
  });

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final TextEditingController controller = TextEditingController();

  Future<void> _showCustomPopup(double amount) async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF5F0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "عمل رائع كان ادخارك جيد هذا الاسبوع",
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text("أضفت $amount ريال")
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 239, 228),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'ادخر اليوم لتحقق احلامك غدًا',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD18B5F),
                ),
              ),
              const SizedBox(height: 15),
              // ---------------------- بوكس الهدف ----------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE1ECF2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.track_changes, color: Color(0xFF162A37)),
                        SizedBox(width: 8),
                        Text(
                          'الهدف الحالي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 22, 42, 55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'المركز الصيفي',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.star, color: Color(0xFFF5B301), size: 20),
                              SizedBox(width: 4),
                              Text(
                                '541 ريال',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearPercentIndicator(
                            animation: true,
                            animationDuration: 800,
                            lineHeight: 10.0,
                            percent: (widget.savedAmount / widget.goalAmount).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[300],
                            progressColor: const Color(0xFFD18B5F),
                            barRadius: const Radius.circular(8),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${((widget.savedAmount / widget.goalAmount) * 100).toStringAsFixed(1)}% مكتمل',
                              style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.savedAmount.toStringAsFixed(0)} / ${widget.goalAmount.toStringAsFixed(0)} ريال',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 248, 247, 246),
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.access_time, color: Color(0xFFD18B5F), size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'الوقت المتوقع: 3 أسابيع',
                                    style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // ---------------------- بوكس الادخار ----------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color.fromARGB(255, 218, 217, 255)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'أضف مدخرات',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF162A37),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.add, color: Color(0xFF162A37)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'المبلغ (ريال)',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFD18B5F), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF162A37)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        double amount = double.tryParse(controller.text) ?? 0.0;
                        if (amount > 0) {
                          widget.onAddAmount(amount);
                          controller.clear();
                          _showCustomPopup(amount);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'أضف إلى مدخراتي',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD18B5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
