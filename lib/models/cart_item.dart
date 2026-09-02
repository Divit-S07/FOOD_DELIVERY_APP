import 'food_item.dart';

class CartItem {
  final String id;
  final FoodItem foodItem;
  int quantity;
  final String selectedSize;
  final List<AddOn> selectedAddOns;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.foodItem,
    this.quantity = 1,
    this.selectedSize = 'Regular',
    this.selectedAddOns = const [],
    this.specialInstructions,
  });

  double get sizeMultiplier {
    switch (selectedSize.toLowerCase()) {
      case 'medium':
        return 1.25;
      case 'large':
        return 1.5;
      case 'regular':
      default:
        return 1.0;
    }
  }

  double get unitPrice {
    double base = foodItem.price * sizeMultiplier;
    double addOnsPrice = selectedAddOns.fold(0.0, (sum, addOn) => sum + addOn.price);
    return base + addOnsPrice;
  }

  double get totalPrice {
    return unitPrice * quantity;
  }

  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    List<AddOn>? selectedAddOns,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id,
      foodItem: foodItem,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      foodItem: FoodItem.fromJson(json['foodItem'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      selectedSize: json['selectedSize'] as String? ?? 'Regular',
      selectedAddOns: (json['selectedAddOns'] as List<dynamic>?)
              ?.map((e) => AddOn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedAddOns': selectedAddOns.map((a) => a.toJson()).toList(),
      'specialInstructions': specialInstructions,
    };
  }
}
