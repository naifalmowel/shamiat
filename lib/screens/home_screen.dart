import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/language_provider.dart';
import '../providers/menu_provider.dart';
import '../data/translations.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onViewMenu;

  const HomeScreen({super.key, required this.onViewMenu});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final menuProvider = context.watch<MenuProvider>();
    final isAr = langProvider.isArabic;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = const Color(0xFFBC8A5F);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final rawCarouselItems = menuProvider.carouselItems;
    final validCarouselItems = rawCarouselItems.where((i) => i.imageUrl.isNotEmpty).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 800;

    const carouselTitleColor = Color(0xFFBC8A5F);
    const carouselSubtitleColor = Colors.white;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Balanced Hero Section (Fills upper screen gracefully)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isMobile ? 18 : 28, horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF081C15) : primaryColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: isMobile ? (screenHeight < 700 ? 100 : 115) : 150,
                    width: isMobile ? (screenHeight < 700 ? 100 : 115) : 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: accentColor, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 3),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bg.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'SHAMIAT',
                    style: TextStyle(
                      color: accentColor,
                      letterSpacing: isMobile ? 8 : 12,
                      fontSize: isMobile ? 32 : 44,
                      fontWeight: FontWeight.bold,
                      shadows: const [Shadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 3))],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  
                  Text(
                    'شــــاميات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    Translations.getText('authentic_taste', isAr),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 13 : 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),

            // Daily Offers Section or Empty Offers Banner (Fills center area)
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        child: Row(
                          mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            FaIcon(FontAwesomeIcons.fire, color: accentColor, size: isMobile ? 20 : 22),
                            const SizedBox(width: 10),
                            Text(
                              Translations.getText('daily_offers', isAr),
                              style: TextStyle(
                                fontSize: isMobile ? 22 : 26,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (validCarouselItems.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: isMobile ? (screenHeight < 700 ? 170.0 : 200.0) : 260.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            viewportFraction: isMobile ? 0.88 : 0.92,
                          ),
                          items: validCarouselItems.map((item) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.black12,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl: item.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.shade900),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0.0, 0.5, 1.0],
                                            colors: [
                                              Colors.black.withValues(alpha: 0.2),
                                              Colors.black.withValues(alpha: 0.4),
                                              Colors.black.withValues(alpha: 0.95),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isAr ? item.titleAr : item.titleEn,
                                            style: const TextStyle(
                                              color: carouselTitleColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  isAr ? item.subTitleAr : item.subTitleEn,
                                                  style: const TextStyle(
                                                    color: carouselSubtitleColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (item.price != null && item.price! > 0)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF2D6A4F),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    '${item.price!.toStringAsFixed(0)} AED',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        // Professional empty offers banner
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          padding: EdgeInsets.symmetric(horizontal: 22, vertical: isMobile ? 22 : 30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark 
                                  ? [const Color(0xFF1B2E26), const Color(0xFF081C15)]
                                  : [primaryColor.withValues(alpha: 0.08), primaryColor.withValues(alpha: 0.02)],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.solidStar, color: accentColor, size: isMobile ? 26 : 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAr ? 'انتظروا عروضنا القوية قريباً!' : 'Stay tuned for our special offers soon!',
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      isAr ? 'نقوم بتحضير باقة من العروض والخصومات المميزة لعيونكم' : 'We are preparing exciting discounts and offers for you',
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
                                        color: isDark ? Colors.white60 : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().scale(),
                    ],
                  ),
                ),
              ),
            ),

            // Prominent Action Button
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: isMobile ? 18 : 28),
                child: GestureDetector(
                  onTap: onViewMenu,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, const Color(0xFF2D6A4F)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Translations.getText('explore_menu', isAr),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 18 : 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const FaIcon(FontAwesomeIcons.arrowRight, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
