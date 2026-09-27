import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/settings_provider.dart';
import '../models/app_settings_model.dart';
import '../data/translations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Widget _buildProfessionalCartPrice(CartItem cartItem, bool isDark, Color primaryColor, {double fontSize = 14}) {
    double originalUnit = cartItem.originalUnitPrice;
    double activeUnit = cartItem.activeUnitPrice;
    bool hasDiscount = (cartItem.item.discountPrice ?? 0) > 0;

    if (!hasDiscount) {
      return Text('${activeUnit.toStringAsFixed(0)} AED', 
        style: TextStyle(color: isDark ? Colors.white : primaryColor, fontWeight: FontWeight.bold, fontSize: fontSize));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              originalUnit.toStringAsFixed(0),
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.grey.shade400,
                fontSize: fontSize * 0.85,
                fontWeight: FontWeight.w400,
              ),
            ),
            Transform.rotate(
              angle: -0.15,
              child: Container(
                width: originalUnit.toStringAsFixed(0).length * 8.0,
                height: 1.0,
                color: isDark ? Colors.white24 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          '${activeUnit.toStringAsFixed(0)} AED',
          style: const TextStyle(
            color: Color(0xFF2D6A4F),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Future<void> _launchWhatsApp(BuildContext context, CartProvider cart, bool isAr, double deliveryFee) async {
    final settings = context.read<SettingsProvider>().settings;
    final phone = settings.whatsappNumber.replaceAll('+', '').replaceAll(' ', ''); 
    String message = isAr 
        ? "السلام عليكم شاميات، أود طلب التالي:\n" 
        : "Hello Shamiat! I'd like to place an order:\n\n";
    
    cart.items.forEach((key, cartItem) {
      final name = isAr ? cartItem.item.nameAr : cartItem.item.nameEn;
      final optionsText = cartItem.selectedChoices.isNotEmpty
          ? " (${cartItem.selectedChoices.map((c) => isAr ? c.nameAr : c.nameEn).join('، ')})"
          : "";
      final itemTotal = cartItem.activeUnitPrice * cartItem.quantity;
      message += "• $name$optionsText x${cartItem.quantity} - ${itemTotal.toStringAsFixed(2)} AED\n";
    });
    
    if (deliveryFee > 0) {
      message += isAr ? "\nرسوم التوصيل: $deliveryFee AED" : "\nDelivery Fee: $deliveryFee AED";
    }

    message += isAr 
        ? "\nالإجمالي النهائي: ${(cart.totalAmount + deliveryFee).toStringAsFixed(2)} AED"
        : "\nFinal Total: ${(cart.totalAmount + deliveryFee).toStringAsFixed(2)} AED";
    
    message += "\n\n${Translations.getText('delivery_note', isAr)}";
    
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isAr ? 'لا يمكن فتح واتساب حالياً' : 'Could not launch WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isAr = context.watch<LanguageProvider>().isArabic;
    final settings = context.watch<SettingsProvider>().settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    if (cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(FontAwesomeIcons.cartShopping, size: 60, color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ).animate().scale(duration: 600.ms),
              const SizedBox(height: 25),
              Text(
                Translations.getText('empty_cart', isAr),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                Translations.getText('start_ordering', isAr),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Constrain header
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translations.getText('cart', isAr),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => cart.clearCart(),
                  icon: const FaIcon(FontAwesomeIcons.trash, size: 10, color: Colors.redAccent),
                  label: Text(
                    Translations.getText('clear_all', isAr),
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final cartKey = cart.items.keys.toList()[index];
                  final cartItem = cart.items.values.toList()[index];
                  final item = cartItem.item;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B2E26) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 70,
                            height: 70,
                            color: isDark ? Colors.white10 : Colors.grey.shade100,
                            child: item.imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFBC8A5F)))),
                                    errorWidget: (context, url, error) => Center(child: FaIcon(FontAwesomeIcons.bowlFood, size: 20, color: isDark ? Colors.white24 : Colors.black12)),
                                  )
                                : Center(child: FaIcon(FontAwesomeIcons.bowlFood, size: 20, color: isDark ? Colors.white24 : Colors.black12)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? item.nameAr : item.nameEn,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (cartItem.selectedChoices.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  cartItem.selectedChoices.map((c) => isAr ? c.nameAr : c.nameEn).join('، '),
                                  style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600, fontSize: 11),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),
                              _buildProfessionalCartPrice(cartItem, isDark, Theme.of(context).colorScheme.primary),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                icon: const FaIcon(FontAwesomeIcons.minus, size: 10, color: Colors.grey),
                                onPressed: () => cart.removeSingleItem(cartKey),
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                icon: FaIcon(FontAwesomeIcons.plus, size: 10, color: Theme.of(context).colorScheme.primary),
                                onPressed: () => cart.addItem(item, selectedChoices: cartItem.selectedChoices),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideX(begin: 0.1, end: 0, duration: 400.ms);
                },
              ),
            ),
          ),
        ),
        
        // Summary constrained on web
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildSummary(context, cart, isAr, screenWidth, settings),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cart, bool isAr, double screenWidth, AppSettingsModel settings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isMobile = screenWidth < 800;

    double totalOriginal = cart.totalOriginalAmount;
    double savings = totalOriginal - cart.totalAmount;
    double finalTotal = cart.totalAmount + settings.deliveryFee;

    bool canCheckout = settings.isOpen && cart.totalAmount >= settings.minOrderAmount;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 25 : 40,
        vertical: isMobile ? 25 : 30
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (savings > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  isAr ? "لقد وفرت ${savings.toStringAsFixed(0)} درهم" : "You saved ${savings.toStringAsFixed(0)} AED",
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ).animate().fadeIn().slideY(begin: 0.5, end: 0),
            
            // Delivery Fee Row
            if (settings.deliveryFee > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAr ? 'رسوم التوصيل' : 'Delivery Fee', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    Text('${settings.deliveryFee.toStringAsFixed(2)} AED', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),

            // Minimum Order Notice
            if (cart.totalAmount < settings.minOrderAmount)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  isAr 
                    ? "الحد الأدنى للطلب هو ${settings.minOrderAmount} درهم" 
                    : "Minimum order amount is ${settings.minOrderAmount} AED",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translations.getText('total', isAr),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black87),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (savings > 0)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${(totalOriginal + settings.deliveryFee).toStringAsFixed(0)} AED',
                            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.0),
                          ),
                          Transform.rotate(
                            angle: -0.1,
                            child: Container(
                              width: 60,
                              height: 1.2,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    Text(
                      '${finalTotal.toStringAsFixed(2)} AED',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (!settings.isOpen)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
                child: Text(
                  isAr ? 'المطعم مغلق حالياً' : 'Restaurant is currently closed',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              )
            else
              GestureDetector(
                onTap: canCheckout ? () => _launchWhatsApp(context, cart, isAr, settings.deliveryFee) : null,
                child: Opacity(
                  opacity: canCheckout ? 1.0 : 0.5,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          Translations.getText('order_whatsapp', isAr),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
