import 'dart:async';
import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../data/dummy_data.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();

  // ── Loading / Error state ─────────────────────────────────────────
  bool _isInitializing = true;
  String? _authError;

  // ── Cart Management ───────────────────────────────────────────────
  final List<CartItem> _cartItems = [];
  String? _appliedCoupon;
  double _couponDiscount = 0.0;

  // ── Favorites ─────────────────────────────────────────────────────
  final Set<String> _favoriteFoodIds = {'f1', 'f2', 'f8'};

  // ── Orders ────────────────────────────────────────────────────────
  List<FoodOrder> _orders = [];
  StreamSubscription<List<FoodOrder>>? _ordersSubscription;

  // ── Food Data (fetched from Firestore; falls back to DummyData) ───
  List<FoodItem> _foodItems = [];
  List<FoodCategory> _categories = [];
  List<PromoBannerData> _banners = [];

  // ── User & Address ────────────────────────────────────────────────
  bool _isLoggedIn = false;
  UserProfile _userProfile = const UserProfile(
    name: '',
    email: '',
    phone: '',
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    savedAddresses: [],
  );
  DeliveryAddress? _selectedAddress;

  // ── Filters & Theme ───────────────────────────────────────────────
  String _selectedCategoryId = 'cat_all';
  String _searchQuery = '';
  bool _vegOnlyFilter = false;
  double _minRatingFilter = 0.0;
  bool _isDarkMode = false;

  // ─────────────────────────────────────────────────────────────────
  // Constructor – listen to auth state and load data
  // ─────────────────────────────────────────────────────────────────

  AppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Load food data (Firestore → fallback to dummy)
    await _loadFoodData();

    // Listen to Firebase Auth state changes
    _firebase.authStateChanges.listen((User? user) async {
      if (user != null) {
        _isLoggedIn = true;
        await _onUserSignedIn(user.uid);
      } else {
        _isLoggedIn = false;
        _orders = [];
        _ordersSubscription?.cancel();
        _userProfile = const UserProfile(
          name: '',
          email: '',
          phone: '',
          avatarUrl:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
          savedAddresses: [],
        );
        _selectedAddress = null;
      }
      _isInitializing = false;
      notifyListeners();
    });
  }

  Future<void> _loadFoodData() async {
    try {
      final items = await _firebase.fetchFoodItems();
      final cats = await _firebase.fetchCategories();
      final bans = await _firebase.fetchBanners();

      _foodItems = items.isNotEmpty ? items : DummyData.foodItems;
      _categories = cats.isNotEmpty ? cats : DummyData.categories;
      _banners = bans.isNotEmpty ? bans : DummyData.banners;
    } catch (_) {
      // Fallback to dummy data if Firestore not reachable
      _foodItems = DummyData.foodItems;
      _categories = DummyData.categories;
      _banners = DummyData.banners;
    }
    notifyListeners();
  }

  Future<void> _onUserSignedIn(String uid) async {
    // Fetch profile
    try {
      final profile = await _firebase.fetchUserProfile(uid);
      if (profile != null) {
        _userProfile = profile;
        _selectedAddress = profile.savedAddresses.isNotEmpty
            ? (profile.savedAddresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => profile.savedAddresses.first,
              ))
            : null;
      }
    } catch (_) {}

    // Subscribe to real-time orders
    _ordersSubscription?.cancel();
    _ordersSubscription = _firebase.ordersStream(uid).listen((orders) {
      _orders = orders;
      notifyListeners();
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────

  bool get isInitializing => _isInitializing;
  String? get authError => _authError;

  List<FoodItem> get foodItems => _foodItems;
  List<FoodCategory> get categories => _categories;
  List<PromoBannerData> get banners => _banners;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  Set<String> get favoriteFoodIds => Set.unmodifiable(_favoriteFoodIds);
  List<FoodOrder> get orders => List.unmodifiable(_orders);

  FoodOrder? get activeOrder {
    try {
      return _orders.firstWhere(
        (o) =>
            o.status == OrderStatus.placed ||
            o.status == OrderStatus.preparing ||
            o.status == OrderStatus.outForDelivery,
      );
    } catch (_) {
      return null;
    }
  }

  bool get isLoggedIn => _isLoggedIn;
  UserProfile get userProfile => _userProfile;
  DeliveryAddress get selectedAddress =>
      _selectedAddress ??
      const DeliveryAddress(
        id: '',
        label: 'Home',
        fullAddress: 'Add a delivery address',
        landmark: '',
        city: '',
        postalCode: '',
        isDefault: true,
      );

  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get vegOnlyFilter => _vegOnlyFilter;
  double get minRatingFilter => _minRatingFilter;
  bool get isDarkMode => _isDarkMode;

  String? get appliedCoupon => _appliedCoupon;
  double get couponDiscount => _couponDiscount;

  // ── Pricing Calculations ─────────────────────────────────────────

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee =>
      subtotal == 0 ? 0.0 : (subtotal > 35.0 ? 0.0 : 2.99);

  double get taxesAndPacking => subtotal * 0.08; // 8% tax

  double get grandTotal {
    if (subtotal == 0) return 0.0;
    double total = subtotal + deliveryFee + taxesAndPacking - _couponDiscount;
    return total < 0 ? 0.0 : total;
  }

  // ── Filtered Food Items ──────────────────────────────────────────

  List<FoodItem> get filteredFoodItems {
    return _foodItems.where((food) {
      if (_selectedCategoryId != 'cat_all' &&
          food.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_vegOnlyFilter && !food.isVeg) return false;
      if (food.rating < _minRatingFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = food.name.toLowerCase().contains(query);
        final descMatch = food.description.toLowerCase().contains(query);
        final catMatch = food.categoryName.toLowerCase().contains(query);
        if (!nameMatch && !descMatch && !catMatch) return false;
      }
      return true;
    }).toList();
  }

  // ─────────────────────────────────────────────────────────────────
  // State Mutators — Filters & Theme
  // ─────────────────────────────────────────────────────────────────

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setVegOnlyFilter(bool value) {
    _vegOnlyFilter = value;
    notifyListeners();
  }

  void setMinRatingFilter(double rating) {
    _minRatingFilter = rating;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategoryId = 'cat_all';
    _searchQuery = '';
    _vegOnlyFilter = false;
    _minRatingFilter = 0.0;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────
  // Favorites
  // ─────────────────────────────────────────────────────────────────

  void toggleFavorite(String foodId) {
    if (_favoriteFoodIds.contains(foodId)) {
      _favoriteFoodIds.remove(foodId);
    } else {
      _favoriteFoodIds.add(foodId);
    }
    notifyListeners();
  }

  bool isFavorite(String foodId) => _favoriteFoodIds.contains(foodId);

  // ─────────────────────────────────────────────────────────────────
  // Cart Operations
  // ─────────────────────────────────────────────────────────────────

  void addToCart(
    FoodItem foodItem, {
    int quantity = 1,
    String selectedSize = 'Regular',
    List<AddOn> selectedAddOns = const [],
    String? specialInstructions,
  }) {
    final index = _cartItems.indexWhere((item) =>
        item.foodItem.id == foodItem.id &&
        item.selectedSize == selectedSize &&
        _areAddOnsEqual(item.selectedAddOns, selectedAddOns));

    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          foodItem: foodItem,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedAddOns: List.from(selectedAddOns),
          specialInstructions: specialInstructions,
        ),
      );
    }

    _recalculateDiscount();
    notifyListeners();
  }

  bool _areAddOnsEqual(List<AddOn> list1, List<AddOn> list2) {
    if (list1.length != list2.length) return false;
    final ids1 = list1.map((a) => a.id).toSet();
    final ids2 = list2.map((a) => a.id).toSet();
    return ids1.containsAll(ids2);
  }

  void updateCartQuantity(String cartItemId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      _recalculateDiscount();
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    _recalculateDiscount();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _appliedCoupon = null;
    _couponDiscount = 0.0;
    notifyListeners();
  }

  int getFoodItemCartQuantity(String foodId) {
    return _cartItems
        .where((item) => item.foodItem.id == foodId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // ─────────────────────────────────────────────────────────────────
  // Coupon Logic
  // ─────────────────────────────────────────────────────────────────

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'FOODIE50' || cleanCode == 'ZOMATO50') {
      _appliedCoupon = cleanCode;
      _couponDiscount = subtotal * 0.50;
      notifyListeners();
      return true;
    } else if (cleanCode == 'FREEDEL') {
      _appliedCoupon = cleanCode;
      _couponDiscount = deliveryFee;
      notifyListeners();
      return true;
    } else if (cleanCode == 'WEEKEND10') {
      _appliedCoupon = cleanCode;
      _couponDiscount = 10.00;
      notifyListeners();
      return true;
    } else if (cleanCode == 'FOODIE20') {
      _appliedCoupon = cleanCode;
      _couponDiscount = subtotal * 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _couponDiscount = 0.0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_appliedCoupon != null) {
      applyCoupon(_appliedCoupon!);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Delivery Address
  // ─────────────────────────────────────────────────────────────────

  void selectAddress(DeliveryAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> addAddress(DeliveryAddress newAddress) async {
    final updatedList =
        List<DeliveryAddress>.from(_userProfile.savedAddresses)
          ..add(newAddress);
    _userProfile = UserProfile(
      name: _userProfile.name,
      email: _userProfile.email,
      phone: _userProfile.phone,
      avatarUrl: _userProfile.avatarUrl,
      membershipType: _userProfile.membershipType,
      savedAddresses: updatedList,
    );
    _selectedAddress = newAddress;

    // Persist to Firestore
    final uid = _firebase.currentUid;
    if (uid != null) {
      await _firebase.saveUserProfile(uid, _userProfile);
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────
  // Auth Operations (Firebase)
  // ─────────────────────────────────────────────────────────────────

  /// Async login — returns null on success, error message on failure.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _authError = null;
    try {
      await _firebase.signIn(email, password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      _authError = _friendlyAuthError(e.code);
      return _authError;
    } catch (_) {
      _authError = 'An unexpected error occurred. Please try again.';
      return _authError;
    }
  }

  /// Async register — returns null on success, error message on failure.
  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _authError = null;
    try {
      await _firebase.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      _authError = _friendlyAuthError(e.code);
      return _authError;
    } catch (_) {
      _authError = 'An unexpected error occurred. Please try again.';
      return _authError;
    }
  }

  /// Async logout.
  Future<void> logout() async {
    await _firebase.signOut();
    clearCart();
  }

  /// Send password reset email.
  Future<String?> sendPasswordReset(String email) async {
    try {
      await _firebase.sendPasswordResetEmail(email);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _friendlyAuthError(e.code);
    } catch (_) {
      return 'Failed to send reset email. Please try again.';
    }
  }

  String _friendlyAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Order Operations
  // ─────────────────────────────────────────────────────────────────

  Future<FoodOrder> placeOrder({required String paymentMethod}) async {
    final newOrder = FoodOrder(
      id: 'ZOM-${(10000 + _orders.length * 153 + DateTime.now().second).toString()}',
      items: List.from(_cartItems),
      subtotal: subtotal,
      discount: _couponDiscount,
      deliveryFee: deliveryFee,
      taxes: taxesAndPacking,
      totalAmount: grandTotal,
      status: OrderStatus.placed,
      orderTime: DateTime.now(),
      deliveryAddress: _selectedAddress != null
          ? '${_selectedAddress!.fullAddress}, ${_selectedAddress!.city}'
          : 'No address selected',
      paymentMethod: paymentMethod,
    );

    // Persist to Firestore
    final uid = _firebase.currentUid;
    if (uid != null) {
      await _firebase.placeOrder(uid, newOrder);
    } else {
      // Offline / guest fallback: update local list
      _orders = [newOrder, ..._orders];
    }

    clearCart();
    notifyListeners();
    return newOrder;
  }

  void reorder(FoodOrder order) {
    for (var cartItem in order.items) {
      addToCart(
        cartItem.foodItem,
        quantity: cartItem.quantity,
        selectedSize: cartItem.selectedSize,
        selectedAddOns: cartItem.selectedAddOns,
        specialInstructions: cartItem.specialInstructions,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────
// InheritedNotifier Wrapper for seamless Flutter context access
// ─────────────────────────────────────────────────────────────────

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
