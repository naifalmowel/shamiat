import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewMenu;

  const HomeScreen({super.key, required this.onViewMenu});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isAr = langProvider.isArabic;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<String> offerImages = [
      'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1200', // Meat
      'https://images.unsplash.com/photo-1562967962-22e0735dd105?q=80&w=1200', // Shawarma
      'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=1200', // Crispy
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Refined Hero Section (Modern & Clean)
            Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF081C15) : primaryColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Stack(
                children: [
                  // Subtle Pattern Overlay (Optional)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.network(
                        'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Brand Image (using bg.png as a logo/feature instead of background)
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: accentColor, width: 3),
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/bg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ).animate().fadeIn(duration: 800.ms).scale(),
                            
                            const SizedBox(height: 25),
                            
                            Text(
                              'SHAMIAT',
                              style: TextStyle(
                                color: accentColor,
                                letterSpacing: 8,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5))],
                              ),
                            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                            
                            Text(
                              'شــــاميات',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                            
                            const SizedBox(height: 10),
                            
                            Text(
                              Translations.getText('authentic_taste', isAr),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ).animate().fadeIn(delay: 700.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Daily Offers Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Row(
                      mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        FaIcon(FontAwesomeIcons.fire, color: accentColor, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          Translations.getText('daily_offers', isAr),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                      viewportFraction: 0.88,
                    ),
                    items: offerImages.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(25),
                          alignment: isAr ? Alignment.bottomRight : Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'خصم خاص' : 'SPECIAL DISCOUNT',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                isAr ? 'استمتع بأفضل العروض اليوم' : 'Best Offers Today',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Main Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 60),
              child: GestureDetector(
                onTap: onViewMenu,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, const Color(0xFF2D6A4F)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Translations.getText('explore_menu', isAr),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const FaIcon(FontAwesomeIcons.arrowRight, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms).moveY(begin: 20, end: 0),
            ),
          ],
        ),
      ),
    );
  }
}
