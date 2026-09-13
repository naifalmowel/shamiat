import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, CartProvider cart, bool isAr) async {
    const phone = "971522242919"; 
    String message = isAr 
        ? "السلام عليكم شاميات، أود طلب التالي:\n" 
        : "Hello Shamiat! I'd like to place an order:\n\n";
    
    cart.items.forEach((key, cartItem) {
      final name = isAr ? cartItem.item.nameAr : cartItem.item.nameEn;
      final activePrice = cartItem.item.discountPrice ?? cartItem.item.price;
      message += "• $name x${cartItem.quantity} - ${activePrice * cartItem.quantity} AED\n";
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
        Padding(
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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = cart.items.values.toList()[index];
              final item = cartItem.item;
              final hasDiscount = item.discountPrice != null && item.discountPrice! > 0;
              final activePrice = hasDiscount ? item.discountPrice! : item.price;

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
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (hasDiscount) ...[
                                Text(
                                  '${item.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                '${activePrice.toStringAsFixed(0)} AED',
                                style: TextStyle(
                                  color: hasDiscount ? const Color(0xFF2D6A4F) : Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
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
                            onPressed: () => cart.removeSingleItem(item.id),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: FaIcon(FontAwesomeIcons.plus, size: 10, color: Theme.of(context).colorScheme.primary),
                            onPressed: () => cart.addItem(item),
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
        _buildSummary(context, cart, isAr, screenWidth),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cart, bool isAr, double screenWidth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isSmall = screenWidth < 380;

    // Calculate total savings
    double totalOriginal = 0;
    cart.items.forEach((key, cartItem) {
      totalOriginal += cartItem.item.price * cartItem.quantity;
    });
    double savings = totalOriginal - cart.totalAmount;
    
    return Container(
      padding: EdgeInsets.all(isSmall ? 15 : 25),
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
          children: [
            if (savings > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D6A4F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D6A4F).withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.celebration, color: Color(0xFF2D6A4F), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      isAr ? "لقد وفرت ${savings.toStringAsFixed(0)} درهم في هذا الطلب!" : "You saved ${savings.toStringAsFixed(0)} AED on this order!",
                      style: const TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ).animate().fadeIn().shake(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.getText('total', isAr),
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade700),
                    ),
                    if (savings > 0)
                      Text(
                        '${totalOriginal.toStringAsFixed(0)} AED',
                        style: TextStyle(fontSize: 15, color: Colors.grey, decoration: TextDecoration.lineThrough, height: 1.2),
                      ),
                  ],
                ),
                Text(
                  '${cart.totalAmount.toStringAsFixed(2)} AED',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchWhatsApp(context, cart, isAr),
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
          ],
        ),
      ),
    );
  }
}
