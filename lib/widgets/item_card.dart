import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class ItemCard extends StatelessWidget {
  final MenuItem item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Watch cart to get current quantity
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(item.id);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E26) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Center(child: FaIcon(FontAwesomeIcons.bowlFood, size: 40, color: isDark ? Colors.white24 : Colors.black12)),
                  ),
                ),
                // Price Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text(
                      '${item.price.toStringAsFixed(0)} AED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? item.nameAr : item.nameEn,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      height: 1.2,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr ? item.nameEn : item.nameAr,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  
                  // Interactive Cart Button / Quantity Selector
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: quantity > 0 
                      ? _buildQuantitySelector(context, primaryColor, isDark, quantity)
                      : _buildAddButton(context, primaryColor, isAr),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAddButton(BuildContext context, Color primaryColor, bool isAr) {
    return Material(
      key: const ValueKey('add_btn'),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<CartProvider>().addItem(item);
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.plus, size: 14, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                Translations.getText('add_to_cart', isAr),
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, Color primaryColor, bool isDark, int quantity) {
    return Container(
      key: const ValueKey('qty_selector'),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const FaIcon(FontAwesomeIcons.minus, size: 12, color: Colors.white),
            onPressed: () => context.read<CartProvider>().removeSingleItem(item.id),
          ),
          Text(
            '$quantity',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 12, color: Colors.white),
            onPressed: () => context.read<CartProvider>().addItem(item),
          ),
        ],
      ),
    );
  }
}
