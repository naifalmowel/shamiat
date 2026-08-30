import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, CartProvider cart) async {
    final phone = "971522242919"; 
    String message = "السلام عليكم شاميات، أود طلب التالي:\n"
                     "Hello Shamiat! I'd like to place an order:\n\n";
    
    cart.items.forEach((key, cartItem) {
      message += "• ${cartItem.item.nameAr} x${cartItem.quantity} - ${cartItem.item.price * cartItem.quantity} AED\n";
    });
    
    message += "\nالإجمالي: ${cart.totalAmount.toStringAsFixed(2)} AED";
    message += "\nيرجى تأكيد الطلب. شكراً!";
    
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن فتح واتساب حالياً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('سلة الطلبات - CART'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: const Text('مسح الكل', style: TextStyle(color: Colors.redAccent)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const FaIcon(FontAwesomeIcons.cartShopping, size: 80, color: Colors.white10),
                  ).animate().scale(duration: 600.ms),
                  const SizedBox(height: 30),
                  const Text(
                    'السلة فارغة حالياً',
                    style: TextStyle(fontSize: 22, color: Colors.white54, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ابدأ بإضافة وجباتك المفضلة',
                    style: TextStyle(color: Colors.white30),
                  ),
                ],
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
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(width: 70, height: 70, color: Colors.white10),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.nameAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text('${item.price} AED', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.minus, size: 12, color: Colors.white54),
                                    onPressed: () => cart.removeSingleItem(item.id),
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.plus, size: 12, color: Color(0xFFFFD700)),
                                    onPressed: () => cart.addItem(item),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().slideX(begin: 0.1, end: 0, duration: 300.ms);
                    },
                  ),
                ),
                
                // Summary & Checkout
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الإجمالي - Total', style: TextStyle(fontSize: 18, color: Colors.white70)),
                            Text(
                              '${cart.totalAmount.toStringAsFixed(2)} AED',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () => _launchWhatsApp(context, cart),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF25D366).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 28),
                                SizedBox(width: 15),
                                Text(
                                  'تأكيد الطلب عبر واتساب',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                ),
              ],
            ),
    );
  }
}
