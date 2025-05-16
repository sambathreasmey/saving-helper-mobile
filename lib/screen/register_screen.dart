import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saving_helper/constants/app_color.dart' as app_colors;
import 'package:saving_helper/controllers/register_controller.dart';
import 'package:saving_helper/repository/register_repository.dart';
import 'package:saving_helper/services/api_provider.dart';
import 'package:saving_helper/theme_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(RegisterController registerController, {super.key, required this.title});
  final String title;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController registerController;

  @override
  void initState() {
    super.initState();
    registerController = Get.put(RegisterController(RegisterRepository(ApiProvider())));
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildRegisterTitleBanner(),
                  const SizedBox(height: 25),

                  _buildInputField(label: 'ឈ្មោះពេញ', icon: Icons.person, controller: registerController.fullName),
                  const SizedBox(height: 15),

                  _buildInputField(label: 'ឈ្មោះអ្នកប្រើប្រាស់', icon: Icons.account_circle, controller: registerController.userName),
                  const SizedBox(height: 15),

                  _buildInputField(label: 'អ៊ីមែល', icon: Icons.email, controller: registerController.email, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 15),

                  _buildInputField(label: 'ពាក្យសម្ងាត់', icon: Icons.lock, controller: registerController.password, obscure: true),
                  const SizedBox(height: 25),

                  StatefulBuilder(
                    builder: (context, setState) {
                      List<Color> _colors = [
                        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                      ];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _colors = [
                              Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                              Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                            ];
                          });

                          registerController.login();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _colors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: _colors[1].withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'ចុះឈ្មោះ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'MyBaseFont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'មានគណនីរួចហើយ?',
                        style: TextStyle(fontFamily: 'MyBaseFont', color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Or navigate to login
                        },
                        child: Text(
                          'ចូលគណនី',
                          style: TextStyle(
                            color: app_colors.loveColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyBaseFont',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(2), // border width
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xFF9013FE)),
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: 'MyBaseFont',
              color: Color(0xFF4A90E2),
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: const TextStyle(
            fontFamily: 'MyBaseFont',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget buildRegisterTitleBanner() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.1),
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        final opacity = 1.2 - scale; // 1.0 → 0.2, 1.1 → 0.1
        return Container(
          width: double.infinity,
          height: 140,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9013FE).withOpacity(0.6),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Image.asset(
                      'assets/images/register_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A90E2).withOpacity(0.1),
                        const Color(0xFF9013FE).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        );
      },
      onEnd: () {
        // Rebuild to reverse tween manually if needed (for loop)
      },
    );
  }

}