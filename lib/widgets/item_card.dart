import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final hasDiscount = item.discountPrice != null && item.discountPrice! > 0;

    // Prices
    final originalPrice = item.price;
    final displayPrice = hasDiscount ? item.discountPrice! : item.price;

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
                  child: item.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDark ? Colors.white10 : Colors.grey.shade100,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFBC8A5F)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: FaIcon(FontAwesomeIcons.bowlFood, size: 30, color: isDark ? Colors.white24 : Colors.black12),
                          ),
                        )
                      : Container(
                          color: Colors.grey.withValues(alpha: 0.1),
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.bowlFood, size: 30, color: isDark ? Colors.white24 : Colors.black12),
                          ),
                        ),
                ),
                
                // Branded Discount/Offer Badge
                if (hasDiscount && item.isAvailable)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A4F), // Elegant Deep Green for offers
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
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

                // Not Available Overlay
                if (!item.isAvailable)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? item.nameAr : item.nameEn,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isAr ? item.descriptionAr : item.descriptionEn,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                  ),
                  const Spacer(),
                  
                  // Premium & Super Clear Pricing Area (Fixed positions & Green for discount)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: hasDiscount 
                          ? const Color(0xFF2D6A4F).withValues(alpha: 0.05)
                          : primaryColor.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            '${originalPrice.toStringAsFixed(0)} AED',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '${displayPrice.toStringAsFixed(0)} AED',
                            style: const TextStyle(
                              color: Color(0xFF2D6A4F), // Striking Green for discount price
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ] else ...[
                          Text(
                            isAr ? 'السعر' : 'Price',
                            style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade600),
                          ),
                          Text(
                            '${displayPrice.toStringAsFixed(0)} AED',
                            style: TextStyle(
                              color: isDark ? accentColor : primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
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
          padding: const EdgeInsets.symmetric(vertical: 7),
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
                  fontSize: 12,
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
