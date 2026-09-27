import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class ItemCard extends StatelessWidget {
  final MenuItem item;

  const ItemCard({super.key, required this.item});

  Map<String, double> _getPrices() {
    double p = item.price;
    double d = item.discountPrice ?? 0;
    if (d > 0) {
      return {
        'original': p > d ? p : d,
        'discount': p < d ? p : d,
      };
    }
    return {'original': p, 'discount': 0};
  }

  Widget _buildProfessionalPrice(bool isDark, Color primaryColor, {double fontSize = 15}) {
    final prices = _getPrices();
    final original = prices['original']!;
    final discount = prices['discount']!;
    final hasDiscount = discount > 0;

    if (!hasDiscount) {
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
              original.toStringAsFixed(0),
              style: TextStyle(
                color: isDark ? Colors.white30 : Colors.grey.shade400,
                fontSize: fontSize * 0.8,
                fontWeight: FontWeight.w400,
              ),
            ),
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
            color: const Color(0xFF2D6A4F),
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  void _showItemDetails(BuildContext context, bool isAr, bool isDark) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Map groupIndex -> list of selected choices
    final Map<int, List<OptionChoice>> selectedOptionsMap = {};
    for (int i = 0; i < item.options.length; i++) {
      final group = item.options[i];
      if (group.type == 'single' && group.choices.isNotEmpty) {
        selectedOptionsMap[i] = [group.choices.first];
      } else {
        selectedOptionsMap[i] = [];
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double extraPrice = 0.0;
            List<OptionChoice> allSelectedChoices = [];
            selectedOptionsMap.values.forEach((list) {
              for (var c in list) {
                extraPrice += c.price;
                allSelectedChoices.add(c);
              }
            });

            double basePrice = (item.discountPrice ?? 0) > 0 ? item.discountPrice! : item.price;
            double currentItemTotal = basePrice + extraPrice;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF081C15) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10))),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 220,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: item.imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: item.imageUrl, 
                                      fit: BoxFit.cover,
                                      memCacheWidth: 600,
                                      placeholder: (c,u) => const Center(child: CircularProgressIndicator()), 
                                      errorWidget: (c,u,e) => const Icon(Icons.fastfood, size: 80, color: Colors.grey))
                                  : Container(color: Colors.grey.shade100, child: const Icon(Icons.fastfood, size: 100, color: Colors.black12)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isAr ? item.nameAr : item.nameEn, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                if ((isAr ? item.descriptionAr : item.descriptionEn).isNotEmpty)
                                  Text(isAr ? item.descriptionAr : item.descriptionEn, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(isAr ? 'السعر الأساسي' : 'Base Price', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    _buildProfessionalPrice(isDark, primaryColor, fontSize: 18),
                                  ],
                                ),
                                
                                // Options & Add-ons
                                if (item.options.isNotEmpty) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Divider(),
                                  ),
                                  Text(
                                    isAr ? 'الخيارات والإضافات' : 'Options & Add-ons',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  ...List.generate(item.options.length, (groupIndex) {
                                    final group = item.options[groupIndex];
                                    final isSingle = group.type == 'single';
                                    final selectedList = selectedOptionsMap[groupIndex] ?? [];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                isAr ? group.titleAr : group.titleEn,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: (isSingle || group.required) 
                                                      ? primaryColor.withValues(alpha: 0.1)
                                                      : Colors.grey.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  (isSingle || group.required) 
                                                      ? (isAr ? 'إجباري' : 'Required') 
                                                      : (isAr ? 'اختياري' : 'Optional'),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: (isSingle || group.required) ? primaryColor : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          ...group.choices.map((choice) {
                                            final isSelected = selectedList.contains(choice);

                                            return InkWell(
                                              onTap: () {
                                                setModalState(() {
                                                  if (isSingle) {
                                                    selectedOptionsMap[groupIndex] = [choice];
                                                  } else {
                                                    if (isSelected) {
                                                      selectedOptionsMap[groupIndex]?.remove(choice);
                                                    } else {
                                                      selectedOptionsMap[groupIndex]?.add(choice);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      isSingle
                                                          ? (isSelected ? Icons.radio_button_checked : Icons.radio_button_off)
                                                          : (isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                                                      color: isSelected ? primaryColor : Colors.grey,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        isAr ? choice.nameAr : choice.nameEn,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                        ),
                                                      ),
                                                    ),
                                                    if (choice.price > 0)
                                                      Text(
                                                        '+${choice.price.toStringAsFixed(0)} AED',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF2D6A4F),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        context.read<CartProvider>().addItem(item, selectedChoices: allSelectedChoices);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Translations.getText('add_to_cart', isAr),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '(${currentItemTotal.toStringAsFixed(2)} AED)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFBC8A5F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleAddToCart(BuildContext context, bool isAr, bool isDark) {
    if (item.options.isNotEmpty) {
      _showItemDetails(context, isAr, isDark);
    } else {
      context.read<CartProvider>().addItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(item.id);
    final hasDiscount = (item.discountPrice ?? 0) > 0;

    return RepaintBoundary(
      child: Container(
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
                          ? CachedNetworkImage(
                              imageUrl: item.imageUrl, 
                              fit: BoxFit.cover,
                              memCacheWidth: 300,
                              filterQuality: FilterQuality.low,
                              errorWidget: (c,u,e) => const Icon(Icons.fastfood, color: Colors.grey),
                            )
                          : Container(color: Colors.grey.withValues(alpha: 0.1), child: const Icon(Icons.fastfood, color: Colors.grey)),
                    ),
                    if (hasDiscount && item.isAvailable)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF2D6A4F), borderRadius: BorderRadius.circular(6)),
                          child: const Text('OFFER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9)),
                        ),
                      ),
                    if (!item.isAvailable)
                      Container(
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.orange.shade900, borderRadius: BorderRadius.circular(8)),
                            child: const Text('COMING SOON', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showItemDetails(context, isAr, isDark),
                      child: Text(isAr ? item.nameAr : item.nameEn, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2, color: isDark ? Colors.white : const Color(0xFF1A1A1A)), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : primaryColor.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: _buildProfessionalPrice(isDark, primaryColor, fontSize: 14),
                      ),
                    ),
                    if (item.isAvailable)
                      SizedBox(
                        height: 38,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: quantity > 0 
                            ? _buildQuantitySelector(context, primaryColor, quantity, isAr, isDark) 
                            : _buildAddButton(context, primaryColor, isAr, isDark),
                        ),
                      )
                    else
                      Container(width: double.infinity, height: 38, padding: const EdgeInsets.symmetric(vertical: 6), decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const Text('Unavailable', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, Color primaryColor, bool isAr, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleAddToCart(context, isAr, isDark),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity, 
          height: 38,
          padding: const EdgeInsets.symmetric(vertical: 4), 
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

  Widget _buildQuantitySelector(BuildContext context, Color primaryColor, int quantity, bool isAr, bool isDark) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 4), 
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32), 
            padding: EdgeInsets.zero, 
            icon: const FaIcon(FontAwesomeIcons.minus, size: 10, color: Colors.white), 
            onPressed: () => context.read<CartProvider>().removeSingleItem(item.id),
          ), 
          Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), 
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32), 
            padding: EdgeInsets.zero, 
            icon: const FaIcon(FontAwesomeIcons.plus, size: 10, color: Colors.white), 
            onPressed: () => _handleAddToCart(context, isAr, isDark),
          )
        ]
      )
    );
  }
}
