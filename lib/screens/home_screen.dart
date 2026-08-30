import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewMenu;

  const HomeScreen({super.key, required this.onViewMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image from Assets
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Gradient Overlay for Premium Feel
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Logo or Main Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFD700), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.utensils,
                        color: Color(0xFFFFD700),
                        size: 60,
                      ),
                    ).animate().fadeIn(duration: 800.ms).scale().shimmer(delay: 1.seconds),
                    
                    const SizedBox(height: 30),
                    
                    Text(
                      'SHAMIAT',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: const Color(0xFFFFD700),
                            letterSpacing: 8,
                            fontSize: 48,
                          ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                    
                    Text(
                      'شــــاميات',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 15),
                    
                    Container(
                      width: 50,
                      height: 2,
                      color: const Color(0xFFFFD700),
                    ).animate().scaleX(delay: 700.ms),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'الذوق الشامي الأصيل في قلب رأس الخيمة\nAuthentic Levantine Taste',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                    
                    const Spacer(),
                    
                    // Call to Action Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: GestureDetector(
                        onTap: onViewMenu,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'اكتشف المنيو ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                              FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: Colors.black),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 1200.ms).moveY(begin: 20, end: 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
