class AddOn {
  final String id;
  final String name;
  final double price;

  const AddOn({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String categoryId;
  final String categoryName;
  final int calories;
  final String prepTime;
  final bool isVeg;
  final bool isPopular;
  final List<String> availableSizes;
  final List<AddOn> addOns;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    required this.calories,
    required this.prepTime,
    this.isVeg = true,
    this.isPopular = false,
    this.availableSizes = const ['Regular', 'Medium', 'Large'],
    this.addOns = const [],
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      calories: (json['calories'] as num).toInt(),
      prepTime: json['prepTime'] as String,
      isVeg: json['isVeg'] as bool? ?? true,
      isPopular: json['isPopular'] as bool? ?? false,
      availableSizes: (json['availableSizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Regular', 'Medium', 'Large'],
      addOns: (json['addOns'] as List<dynamic>?)
              ?.map((e) => AddOn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'calories': calories,
      'prepTime': prepTime,
      'isVeg': isVeg,
      'isPopular': isPopular,
      'availableSizes': availableSizes,
      'addOns': addOns.map((a) => a.toJson()).toList(),
    };
  }
}

class FoodCategory {
  final String id;
  final String name;
  final String iconName;
  final String imageUrl;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.imageUrl,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'imageUrl': imageUrl,
    };
  }
}
