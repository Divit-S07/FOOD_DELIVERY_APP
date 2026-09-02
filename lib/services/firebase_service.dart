import 'dart:async';
import '../models/food_item.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../data/dummy_data.dart';

// ─────────────────────────────────────────────────────────────────
// Simple Auth Exception (replaces FirebaseAuthException)
// ─────────────────────────────────────────────────────────────────

class AuthException implements Exception {
  final String code;
  final String message;
  const AuthException({required this.code, required this.message});
  @override
  String toString() => 'AuthException($code): $message';
}

// ─────────────────────────────────────────────────────────────────
// Lightweight local user record
// ─────────────────────────────────────────────────────────────────

class _LocalUser {
  final String uid;
  final String email;
  final String passwordHash; // stored as plain string for demo purposes
  UserProfile profile;

  _LocalUser({
    required this.uid,
    required this.email,
    required this.passwordHash,
    required this.profile,
  });
}

// ─────────────────────────────────────────────────────────────────
// FirebaseService — local in-memory replacement
// ─────────────────────────────────────────────────────────────────

/// Replaces the original Firebase-backed service.
/// All auth and data operations are fully local / in-memory.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // ── In-memory stores ─────────────────────────────────────────
  final Map<String, _LocalUser> _users = {}; // uid → user
  final Map<String, List<FoodOrder>> _orders = {}; // uid → orders
  _LocalUser? _currentUser;

  // ── Auth state stream ─────────────────────────────────────────
  final _authController = StreamController<String?>.broadcast();

  // ─────────────────────────────────────────────────────────────
  // Auth helpers
  // ─────────────────────────────────────────────────────────────

  String? get currentUid => _currentUser?.uid;

  /// Stream of nullable uid (null = signed out).
  Stream<String?> get authStateChanges => _authController.stream;

  /// Sign in with email and password.
  Future<UserProfile> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final user = _users.values.cast<_LocalUser?>().firstWhere(
          (u) => u!.email.toLowerCase() == email.trim().toLowerCase(),
          orElse: () => null,
        );

    if (user == null) {
      throw const AuthException(
        code: 'user-not-found',
        message: 'No account found with this email.',
      );
    }
    if (user.passwordHash != password) {
      throw const AuthException(
        code: 'wrong-password',
        message: 'Incorrect password.',
      );
    }

    _currentUser = user;
    _authController.add(user.uid);
    return user.profile;
  }

  /// Register a new user and return their profile.
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final exists = _users.values.any(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (exists) {
      throw const AuthException(
        code: 'email-already-in-use',
        message: 'An account already exists with this email.',
      );
    }

    final uid = 'uid_${DateTime.now().millisecondsSinceEpoch}';
    final profile = UserProfile(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      membershipType: 'Zomato Gold VIP',
      savedAddresses: const [
        DeliveryAddress(
          id: 'addr_default',
          label: 'Home',
          fullAddress: 'Please update your address',
          landmark: '',
          city: 'Your City',
          postalCode: '000000',
          isDefault: true,
        ),
      ],
    );

    final localUser = _LocalUser(
      uid: uid,
      email: email.trim(),
      passwordHash: password,
      profile: profile,
    );

    _users[uid] = localUser;
    _orders[uid] = [];
    _currentUser = localUser;
    _authController.add(uid);
    return profile;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _currentUser = null;
    _authController.add(null);
  }

  /// Password reset is a no-op locally — just succeeds silently.
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In a local/offline context, we simply do nothing.
    // The caller shows a success message.
  }

  // ─────────────────────────────────────────────────────────────
  // User Profile
  // ─────────────────────────────────────────────────────────────

  Future<UserProfile?> fetchUserProfile(String uid) async {
    return _users[uid]?.profile;
  }

  Future<void> saveUserProfile(String uid, UserProfile profile) async {
    if (_users.containsKey(uid)) {
      _users[uid]!.profile = profile;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Food Items & Categories  (always from DummyData)
  // ─────────────────────────────────────────────────────────────

  Future<List<FoodItem>> fetchFoodItems() async => DummyData.foodItems;

  Future<List<FoodCategory>> fetchCategories() async => DummyData.categories;

  Future<List<PromoBannerData>> fetchBanners() async => DummyData.banners;

  // ─────────────────────────────────────────────────────────────
  // Orders
  // ─────────────────────────────────────────────────────────────

  Future<void> placeOrder(String uid, FoodOrder order) async {
    _orders.putIfAbsent(uid, () => []);
    _orders[uid]!.insert(0, order);
    _ordersControllers[uid]?.add(List.unmodifiable(_orders[uid]!));
  }

  Future<List<FoodOrder>> fetchUserOrders(String uid) async {
    return List.unmodifiable(_orders[uid] ?? []);
  }

  // Per-user order stream controllers
  final Map<String, StreamController<List<FoodOrder>>> _ordersControllers = {};

  Stream<List<FoodOrder>> ordersStream(String uid) {
    _ordersControllers.putIfAbsent(
      uid,
      () => StreamController<List<FoodOrder>>.broadcast(
        onListen: () {
          // Emit current state immediately on subscribe
          _ordersControllers[uid]?.add(
            List.unmodifiable(_orders[uid] ?? []),
          );
        },
      ),
    );
    // Emit the current list on every new subscription
    Future.microtask(() {
      _ordersControllers[uid]?.add(
        List.unmodifiable(_orders[uid] ?? []),
      );
    });
    return _ordersControllers[uid]!.stream;
  }

  // ─────────────────────────────────────────────────────────────
  // Seed (no-op — data comes from DummyData directly)
  // ─────────────────────────────────────────────────────────────

  Future<void> seedDataIfNeeded() async {
    // Nothing to seed; DummyData is the source of truth.
  }
}
