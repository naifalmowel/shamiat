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

  // Widget مخصص للسعر المشطوب بطريقة احترافية لا تخفي الأرقام
  Widget _buildProfessionalPrice(double original, double? discount, bool isDark, Color primaryColor, {double fontSize = 15}) {
    if (discount == null || discount <= 0) {
      return Text('${original.toStringAsFixed(0)} AED', 
        style: TextStyle(color: isDark ? Colors.white : primaryColor, fontWeight: FontWeight.bold, fontSize: fontSize));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${original.toStringAsFixed(0)}',
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.grey.shade400,
                fontSize: fontSize * 0.8,
                fontWeight: FontWeight.w400,
              ),
            ),
            // خط شطب يدوي رفيع جداً وأنيق لضمان وضوح الأرقام
            Transform.rotate(
              angle: -0.15,
              child: Container(
                width: original.toStringAsFixed(0).length * 8.0,
                height: 1.2,
                color: isDark ? Colors.white24 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          '${discount.toStringAsFixed(0)} AED',
          style: TextStyle(
            color: const Color(0xFF2D6A4F), // الأخضر الخاص بالعروض
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  void _showItemDetails(BuildContext context, bool isAr, bool isDark) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final hasDiscount = item.discountPrice != null && item.discountPrice! > 0;
    final displayPrice = hasDiscount ? item.discountPrice! : item.price;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF081C15) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.all(12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10))),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: item.imageUrl.isNotEmpty
                            ? CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover, placeholder: (c,u) => const Center(child: CircularProgressIndicator()), errorWidget: (c,u,e) => const Icon(Icons.fastfood, size: 80, color: Colors.grey))
                            : Container(color: Colors.grey.shade100, child: const Icon(Icons.fastfood, size: 100, color: Colors.black12)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(isAr ? item.nameAr : item.nameEn, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(isAr ? item.descriptionAr : item.descriptionEn, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isAr ? 'السعر' : 'Price', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              _buildProfessionalPrice(item.price, item.discountPrice, isDark, primaryColor, fontSize: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  context.read<CartProvider>().addItem(item);
                  Navigator.pop(context);
                },
                child: Text(Translations.getText('add_to_cart', isAr), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(item.id);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E26) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () => _showItemDetails(context, isAr, isDark),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: item.imageUrl.isNotEmpty
                        ? CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover, errorWidget: (c,u,e) => const Icon(Icons.fastfood, color: Colors.grey))
                        : Container(color: Colors.grey.withValues(alpha: 0.1), child: const Icon(Icons.fastfood, color: Colors.grey)),
                  ),
                  if (item.discountPrice != null && item.discountPrice! > 0 && item.isAvailable)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2D6A4F), borderRadius: BorderRadius.circular(6)),
                        child: Text(isAr ? 'عرض' : 'OFFER', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9)),
                      ),
                    ),
                  if (!item.isAvailable)
                    Container(
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.orange.shade900, borderRadius: BorderRadius.circular(8)),
                          child: Text(isAr ? 'يتوفر قريباً' : 'COMING SOON', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showItemDetails(context, isAr, isDark),
                    child: Text(isAr ? item.nameAr : item.nameEn, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2, color: isDark ? Colors.white : const Color(0xFF1A1A1A)), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: isAr ? TextAlign.right : TextAlign.left),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : primaryColor.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: _buildProfessionalPrice(item.price, item.discountPrice, isDark, primaryColor, fontSize: 14),
                    ),
                  ),
                  if (item.isAvailable)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: quantity > 0 
                        ? _buildQuantitySelector(context, primaryColor, quantity) 
                        : _buildAddButton(context, primaryColor, isAr),
                    )
                  else
                    Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 6), decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(isAr ? 'مغلق مؤقتاً' : 'Unavailable', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.read<CartProvider>().addItem(item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity, 
          padding: const EdgeInsets.symmetric(vertical: 7), 
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1), 
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: primaryColor.withValues(alpha: 0.2))
          ), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              FaIcon(FontAwesomeIcons.plus, size: 10, color: primaryColor), 
              const SizedBox(width: 6), 
              Text(Translations.getText('add_to_cart', isAr), style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12))
            ]
          )
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, Color primaryColor, int quantity) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4), decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, icon: const FaIcon(FontAwesomeIcons.minus, size: 10, color: Colors.white), onPressed: () => context.read<CartProvider>().removeSingleItem(item.id)), Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), IconButton(constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, icon: const FaIcon(FontAwesomeIcons.plus, size: 10, color: Colors.white), onPressed: () => context.read<CartProvider>().addItem(item))]));
  }
}
