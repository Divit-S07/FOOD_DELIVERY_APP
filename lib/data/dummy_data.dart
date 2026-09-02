import '../models/food_item.dart';
import '../models/user_profile.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class PromoBannerData {
  final String id;
  final String title;
  final String subtitle;
  final String code;
  final String discount;
  final String imageUrl;

  const PromoBannerData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.discount,
    required this.imageUrl,
  });
}

class DummyData {
  static final List<FoodCategory> categories = [
    const FoodCategory(
      id: 'cat_all',
      name: 'All Foods',
      iconName: 'restaurant',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_burgers',
      name: 'Burgers',
      iconName: 'lunch_dining',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_pizza',
      name: 'Pizza',
      iconName: 'local_pizza',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_indian',
      name: 'Biryani & Indian',
      iconName: 'rice_bowl',
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_sushi',
      name: 'Sushi & Asian',
      iconName: 'ramen_dining',
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_tacos',
      name: 'Tacos & Mexican',
      iconName: 'bakery_dining',
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_desserts',
      name: 'Desserts',
      iconName: 'cake',
      imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=400&q=80',
    ),
    const FoodCategory(
      id: 'cat_drinks',
      name: 'Drinks & Shakes',
      iconName: 'local_bar',
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  static final List<PromoBannerData> banners = [
    const PromoBannerData(
      id: 'b1',
      title: '50% OFF',
      subtitle: 'On your first 3 food orders',
      code: 'FOODIE50',
      discount: '50% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
    ),
    const PromoBannerData(
      id: 'b2',
      title: 'FREE DELIVERY',
      subtitle: 'On orders over \$20',
      code: 'FREEDEL',
      discount: 'FREE SHIP',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80',
    ),
    const PromoBannerData(
      id: 'b3',
      title: 'FLAT \$10 OFF',
      subtitle: 'Weekend Gourmet Feast Deal',
      code: 'WEEKEND10',
      discount: '\$10 OFF',
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  static final List<AddOn> burgerAddOns = [
    const AddOn(id: 'a1', name: 'Extra Cheddar Cheese', price: 1.50),
    const AddOn(id: 'a2', name: 'Crispy Bacon Strips', price: 2.50),
    const AddOn(id: 'a3', name: 'Caramelized Onions', price: 1.00),
    const AddOn(id: 'a4', name: 'Truffle Mayo Dip', price: 1.25),
  ];

  static final List<AddOn> pizzaAddOns = [
    const AddOn(id: 'a5', name: 'Extra Mozzarella Crust', price: 3.00),
    const AddOn(id: 'a6', name: 'Garlic Butter Sauce', price: 1.00),
    const AddOn(id: 'a7', name: 'Spicy Jalapenos', price: 1.20),
    const AddOn(id: 'a8', name: 'Pepperoni Slices', price: 2.00),
  ];

  static final List<FoodItem> foodItems = [
    FoodItem(
      id: 'f1',
      name: 'Smokey Bacon Cheeseburger',
      description: 'Charbroiled double beef patty with melted cheddar cheese, applewood smoked bacon, caramelized onions, fresh lettuce, and signature house BBQ mayo sauce served on a toasted brioche bun.',
      price: 12.99,
      rating: 4.8,
      reviewCount: 342,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_burgers',
      categoryName: 'Burgers',
      calories: 780,
      prepTime: '20-25 min',
      isVeg: false,
      isPopular: true,
      addOns: burgerAddOns,
    ),
    FoodItem(
      id: 'f2',
      name: 'Truffle Mushroom Pizza',
      description: 'Artisanal wood-fired pizza topped with white truffle oil, wild mushrooms, fresh mozzarella, aromatic thyme, and garlic white sauce.',
      price: 16.50,
      rating: 4.9,
      reviewCount: 512,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_pizza',
      categoryName: 'Pizza',
      calories: 920,
      prepTime: '25-30 min',
      isVeg: true,
      isPopular: true,
      addOns: pizzaAddOns,
    ),
    FoodItem(
      id: 'f3',
      name: 'Royal Hyderabadi Dum Biryani',
      description: 'Fragrant basmati rice layered with tender spiced chicken marinated in yogurt, saffron, mint, and fried onions. Served with raita and salan.',
      price: 14.99,
      rating: 4.7,
      reviewCount: 890,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_indian',
      categoryName: 'Biryani & Indian',
      calories: 850,
      prepTime: '30-35 min',
      isVeg: false,
      isPopular: true,
      addOns: [
        const AddOn(id: 'a9', name: 'Extra Raita', price: 1.00),
        const AddOn(id: 'a10', name: 'Boiled Egg', price: 1.50),
      ],
    ),
    FoodItem(
      id: 'f4',
      name: 'Dragon Salmon Sushi Roll',
      description: 'Fresh Atlantic salmon roll with avocado, cucumber, unagi sauce, spicy mayo, and toasted sesame seeds.',
      price: 18.00,
      rating: 4.9,
      reviewCount: 215,
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_sushi',
      categoryName: 'Sushi & Asian',
      calories: 540,
      prepTime: '15-20 min',
      isVeg: false,
      isPopular: true,
      addOns: [
        const AddOn(id: 'a11', name: 'Extra Wasabi & Ginger', price: 0.50),
        const AddOn(id: 'a12', name: 'Spicy Mayo Dip', price: 1.00),
      ],
    ),
    FoodItem(
      id: 'f5',
      name: 'Crispy Veggie Garden Burger',
      description: 'Crispy quinoa and black bean patty with fresh avocado slice, pickled red onions, butter lettuce, and vegan chipotle aioli.',
      price: 11.50,
      rating: 4.6,
      reviewCount: 178,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_burgers',
      categoryName: 'Burgers',
      calories: 520,
      prepTime: '15-20 min',
      isVeg: true,
      isPopular: false,
      addOns: burgerAddOns,
    ),
    FoodItem(
      id: 'f6',
      name: 'Classic Pepperoni Feast Pizza',
      description: 'Rich tomato herb sauce, triple layer mozzarella cheese, and crispy savory pepperoni slices baked on hand-tossed dough.',
      price: 15.99,
      rating: 4.8,
      reviewCount: 620,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_pizza',
      categoryName: 'Pizza',
      calories: 980,
      prepTime: '20-25 min',
      isVeg: false,
      isPopular: true,
      addOns: pizzaAddOns,
    ),
    FoodItem(
      id: 'f7',
      name: 'Street Style Birria Tacos',
      description: 'Three slow-braised beef birria tacos in crispy corn tortillas dipped in consommé broth, cilantro, onions, and spicy salsa verde.',
      price: 13.50,
      rating: 4.9,
      reviewCount: 440,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_tacos',
      categoryName: 'Tacos & Mexican',
      calories: 690,
      prepTime: '20 min',
      isVeg: false,
      isPopular: true,
      addOns: [
        const AddOn(id: 'a13', name: 'Extra Consommé Dip', price: 1.50),
        const AddOn(id: 'a14', name: 'Fresh Guacamole', price: 2.00),
      ],
    ),
    FoodItem(
      id: 'f8',
      name: 'Belgian Molten Lava Cake',
      description: 'Warm dark chocolate cake with a rich flowing molten center, served with vanilla bean ice cream scoop and raspberry drizzle.',
      price: 8.99,
      rating: 4.9,
      reviewCount: 390,
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_desserts',
      categoryName: 'Desserts',
      calories: 460,
      prepTime: '10-15 min',
      isVeg: true,
      isPopular: true,
      addOns: [
        const AddOn(id: 'a15', name: 'Extra Ice Cream Scoop', price: 2.00),
      ],
    ),
    FoodItem(
      id: 'f9',
      name: 'Iced Caramel Macchiato',
      description: 'Fresh espresso combined with cold milk, sweet vanilla syrup, and drizzled with buttery caramel sauce over ice.',
      price: 5.49,
      rating: 4.7,
      reviewCount: 230,
      imageUrl: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_drinks',
      categoryName: 'Drinks & Shakes',
      calories: 280,
      prepTime: '5-10 min',
      isVeg: true,
      isPopular: false,
      addOns: [
        const AddOn(id: 'a16', name: 'Extra Espresso Shot', price: 1.25),
        const AddOn(id: 'a17', name: 'Oat Milk Swap', price: 0.75),
      ],
    ),
    FoodItem(
      id: 'f10',
      name: 'Butter Chicken & Garlic Naan',
      description: 'Tender chicken tikka cooked in rich creamy tomato butter sauce, flavored with fenugreek leaves. Served with hot garlic butter naan.',
      price: 15.49,
      rating: 4.8,
      reviewCount: 710,
      imageUrl: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=600&q=80',
      categoryId: 'cat_indian',
      categoryName: 'Biryani & Indian',
      calories: 820,
      prepTime: '25 min',
      isVeg: false,
      isPopular: true,
      addOns: [
        const AddOn(id: 'a18', name: 'Extra Garlic Naan', price: 2.50),
        const AddOn(id: 'a19', name: 'Jeera Rice', price: 3.00),
      ],
    ),
  ];

  static const UserProfile userProfile = UserProfile(
    name: 'Alex Johnson',
    email: 'alex.johnson@example.com',
    phone: '+1 (555) 234-5678',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    membershipType: 'Zomato Gold VIP Member',
    savedAddresses: [
      DeliveryAddress(
        id: 'addr_1',
        label: 'Home',
        fullAddress: '742 Evergreen Terrace, Apt 4B',
        landmark: 'Near Central Park',
        city: 'New York',
        postalCode: '10001',
        isDefault: true,
      ),
      DeliveryAddress(
        id: 'addr_2',
        label: 'Office',
        fullAddress: '350 Fifth Avenue, Floor 18',
        landmark: 'Empire State Building',
        city: 'New York',
        postalCode: '10118',
        isDefault: false,
      ),
    ],
  );

  static final List<FoodOrder> initialOrders = [
    FoodOrder(
      id: 'ZOM-94821',
      items: [
        CartItem(
          id: 'ci_1',
          foodItem: foodItems[0],
          quantity: 2,
          selectedSize: 'Medium',
          selectedAddOns: [burgerAddOns[0]],
        ),
        CartItem(
          id: 'ci_2',
          foodItem: foodItems[7],
          quantity: 1,
        ),
      ],
      subtotal: 41.47,
      discount: 5.00,
      deliveryFee: 2.99,
      taxes: 3.20,
      totalAmount: 42.66,
      status: OrderStatus.preparing,
      orderTime: DateTime.now().subtract(const Duration(minutes: 18)),
      deliveryAddress: '742 Evergreen Terrace, Apt 4B',
      paymentMethod: 'Google Pay (UPI)',
    ),
    FoodOrder(
      id: 'ZOM-81204',
      items: [
        CartItem(
          id: 'ci_3',
          foodItem: foodItems[1],
          quantity: 1,
          selectedSize: 'Large',
        ),
      ],
      subtotal: 24.75,
      discount: 0.00,
      deliveryFee: 2.99,
      taxes: 1.98,
      totalAmount: 29.72,
      status: OrderStatus.delivered,
      orderTime: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      deliveryAddress: '350 Fifth Avenue, Floor 18',
      paymentMethod: 'Visa Card ending in 4242',
    ),
  ];
}
