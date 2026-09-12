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
    final accentColor = Theme.of(context).colorScheme.secondary;
    
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(item.id);
    final hasDiscount = item.discountPrice != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E26) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Container(
                    color: Colors.grey.withValues(alpha: 0.1),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              Center(child: FaIcon(FontAwesomeIcons.bowlFood, size: 30, color: isDark ? Colors.white24 : Colors.black12)),
                          )
                        : Center(child: FaIcon(FontAwesomeIcons.bowlFood, size: 30, color: isDark ? Colors.white24 : Colors.black12)),
                  ),
                ),
                
                // Discount/Offer Badge
                if (hasDiscount && item.isAvailable)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAr ? 'عرض' : 'OFFER',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),

                // Price Tag
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasDiscount)
                          Text(
                            '${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 9,
                            ),
                          ),
                        Text(
                          '${(hasDiscount ? item.discountPrice! : item.price).toStringAsFixed(0)} AED',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Not Available Overlay
                if (!item.isAvailable)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isAr ? 'غير متوفر' : 'OUT OF STOCK',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? item.nameAr : item.nameEn,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.1,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAr ? item.nameEn : item.nameAr,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  
                  // Interactive Cart Button / Quantity Selector
                  if (item.isAvailable)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: quantity > 0 
                        ? _buildQuantitySelector(context, primaryColor, quantity)
                        : _buildAddButton(context, primaryColor, isAr),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isAr ? 'مغلق مؤقتاً' : 'Unavailable',
                        style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAddButton(BuildContext context, Color primaryColor, bool isAr) {
    return Material(
      key: const ValueKey('add_btn'),
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<CartProvider>().addItem(item);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.plus, size: 10, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                Translations.getText('add_to_cart', isAr),
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, Color primaryColor, int quantity) {
    return Container(
      key: const ValueKey('qty_selector'),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            icon: const FaIcon(FontAwesomeIcons.minus, size: 10, color: Colors.white),
            onPressed: () => context.read<CartProvider>().removeSingleItem(item.id),
          ),
          Text(
            '$quantity',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 10, color: Colors.white),
            onPressed: () => context.read<CartProvider>().addItem(item),
          ),
        ],
      ),
    );
  }
}
