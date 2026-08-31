import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, CartProvider cart, bool isAr) async {
    final phone = "971522242919"; 
    String message = isAr 
        ? "السلام عليكم شاميات، أود طلب التالي:\n" 
        : "Hello Shamiat! I'd like to place an order:\n\n";
    
    cart.items.forEach((key, cartItem) {
      final name = isAr ? cartItem.item.nameAr : cartItem.item.nameEn;
      message += "• $name x${cartItem.quantity} - ${cartItem.item.price * cartItem.quantity} AED\n";
    });
    
    message += isAr 
        ? "\nالإجمالي: ${cart.totalAmount.toStringAsFixed(2)} AED"
        : "\nTotal: ${cart.totalAmount.toStringAsFixed(2)} AED";
    
    message += "\n\n${Translations.getText('delivery_note', isAr)}";
    message += isAr ? "\nيرجى تأكيد الطلب. شكراً!" : "\nPlease confirm my order. Thank you!";
    
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isAr ? 'لا يمكن فتح واتساب حالياً' : 'Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.getText('cart', isAr)),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: Text(
                Translations.getText('clear_all', isAr),
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(FontAwesomeIcons.cartShopping, size: 80, color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                    ).animate().scale(duration: 600.ms),
                    const SizedBox(height: 30),
                    Text(
                      Translations.getText('empty_cart', isAr),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Translations.getText('start_ordering', isAr),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items.values.toList()[index];
                      final item = cartItem.item;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1B2E26) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                item.imageUrl,
                                width: 85,
                                height: 85,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAr ? item.nameAr : item.nameEn,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${item.price} AED',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.plus, size: 14, color: Theme.of(context).colorScheme.primary),
                                    onPressed: () => cart.addItem(item),
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.minus, size: 14, color: Colors.grey),
                                    onPressed: () => cart.removeSingleItem(item.id),
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
                _buildSummary(context, cart, isAr),
              ],
            ),
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cart, bool isAr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E26) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 25, spreadRadius: 5),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Professional Delivery Note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.truckFast, size: 16, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      Translations.getText('delivery_note', isAr),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Translations.getText('total', isAr),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${cart.totalAmount.toStringAsFixed(2)} AED',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _launchWhatsApp(context, cart, isAr),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
                    const SizedBox(width: 18),
                    Text(
                      Translations.getText('order_whatsapp', isAr),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
