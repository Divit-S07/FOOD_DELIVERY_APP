import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/rating_badge.dart';
import '../widgets/quantity_selector.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late String _selectedSize;
  final Set<AddOn> _selectedAddOns = {};
  int _quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.foodItem.availableSizes.isNotEmpty
        ? widget.foodItem.availableSizes.first
        : 'Regular';
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  double get _sizeMultiplier {
    switch (_selectedSize.toLowerCase()) {
      case 'medium':
        return 1.25;
      case 'large':
        return 1.5;
      case 'regular':
      default:
        return 1.0;
    }
  }

  double get _calculatedUnitPrice {
    double base = widget.foodItem.price * _sizeMultiplier;
    double addOnsPrice = _selectedAddOns.fold(0.0, (sum, addOn) => sum + addOn.price);
    return base + addOnsPrice;
  }

  double get _totalPrice => _calculatedUnitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isFavorite = appState.isFavorite(widget.foodItem.id);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Slivers AppBar with Hero Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                leading: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () {
                        appState.toggleFavorite(widget.foodItem.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'food_img_${widget.foodItem.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.foodItem.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primary,
                              child: const Center(
                                child: Icon(Icons.restaurant, size: 80, color: Colors.white),
                              ),
                            );
                          },
                        ),
                        // Gradient Overlay for smooth contrast
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Title & Veg tag
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VegNonVegTag(isVeg: widget.foodItem.isVeg, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.foodItem.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.foodItem.categoryName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Info Badges Row (Rating, Prep Time, Calories)
                      Row(
                        children: [
                          RatingBadge(
                            rating: widget.foodItem.rating,
                            reviewCount: widget.foodItem.reviewCount,
                            fontSize: 13,
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                widget.foodItem.prepTime,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.foodItem.calories} kcal',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.foodItem.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Portion Size Selection
                      if (widget.foodItem.availableSizes.isNotEmpty) ...[
                        const Text(
                          'Select Portion Size',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: widget.foodItem.availableSizes.map((size) {
                            final isSelected = _selectedSize == size;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSize = size;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? AppColors.darkCard : Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.lightBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Extra Add-ons Selection
                      if (widget.foodItem.addOns.isNotEmpty) ...[
                        const Text(
                          'Extra Add-ons',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: widget.foodItem.addOns.map((addOn) {
                            final isChecked = _selectedAddOns.contains(addOn);
                            return CheckboxListTile(
                              value: isChecked,
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                addOn.name,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              subtitle: Text(
                                '+\$${addOn.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedAddOns.add(addOn);
                                  } else {
                                    _selectedAddOns.remove(addOn);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Special Instructions Text Field
                      const Text(
                        'Special Instructions',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _instructionsController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Less spicy, no onions, extra sauce on the side...',
                          prefixIcon: Icon(Icons.edit_note),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity Stepper
                  QuantitySelector(
                    quantity: _quantity,
                    height: 44,
                    onChanged: (newQty) {
                      if (newQty > 0) {
                        setState(() {
                          _quantity = newQty;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 16),

                  // Add to Cart Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        appState.addToCart(
                          widget.foodItem,
                          quantity: _quantity,
                          selectedSize: _selectedSize,
                          selectedAddOns: _selectedAddOns.toList(),
                          specialInstructions: _instructionsController.text.trim().isNotEmpty
                              ? _instructionsController.text.trim()
                              : null,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.shopping_bag, color: Colors.white),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text('Added ${_quantity}x ${widget.foodItem.name} to Cart!'),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.vegGreen,
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Add to Cart'),
                          const SizedBox(width: 8),
                          Text(
                            '• \$${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
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
