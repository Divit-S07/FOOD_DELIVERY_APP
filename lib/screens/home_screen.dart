import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_banner.dart';
import 'food_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onOpenSearch;

  const HomeScreen({
    super.key,
    this.onOpenSearch,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categories = DummyData.categories;
    final banners = DummyData.banners;
    final filteredFoods = appState.filteredFoodItems;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top Location & Notification Header Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delivering to: ${appState.selectedAddress.fullAddress}')),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        appState.selectedAddress.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down, size: 18),
                                    ],
                                  ),
                                  Text(
                                    '${appState.selectedAddress.fullAddress}, ${appState.selectedAddress.city}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Notification Icon Bell
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: const Icon(Icons.notifications_outlined, size: 22),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // User Profile / Login Action Icon
                    GestureDetector(
                      onTap: () {
                        if (!appState.isLoggedIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const LoginScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logged in as ${appState.userProfile.name}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: appState.isLoggedIn ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: appState.isLoggedIn
                              ? NetworkImage(appState.userProfile.avatarUrl)
                              : null,
                          child: !appState.isLoggedIn
                              ? const Icon(Icons.person_outline, size: 18, color: AppColors.primary)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar Shortcut
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: onOpenSearch ?? () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Search food, dishes or restaurants...',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.mic, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Promotional Offer Banners Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 175,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return PromoBannerWidget(
                      banner: banner,
                      onTap: () {
                        appState.applyCoupon(banner.code);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Coupon code  - copied & applied!'),
                            backgroundColor: AppColors.vegGreen,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Categories Header & Horizontal List
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Explore Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = appState.selectedCategoryId == cat.id;
                        return CategoryChip(
                          category: cat,
                          isSelected: isSelected,
                          onTap: () {
                            appState.setCategory(cat.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Quick Filter Chips Row
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      avatar: Icon(
                        Icons.eco,
                        color: appState.vegOnlyFilter ? Colors.white : AppColors.vegGreen,
                        size: 16,
                      ),
                      label: const Text('Veg Only'),
                      selected: appState.vegOnlyFilter,
                      selectedColor: AppColors.vegGreen,
                      labelStyle: TextStyle(
                        color: appState.vegOnlyFilter ? Colors.white : (isDark ? Colors.white : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        appState.setVegOnlyFilter(val);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      avatar: Icon(
                        Icons.star,
                        color: appState.minRatingFilter >= 4.5 ? Colors.white : Colors.amber,
                        size: 16,
                      ),
                      label: const Text('Rating 4.5+'),
                      selected: appState.minRatingFilter >= 4.5,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: appState.minRatingFilter >= 4.5 ? Colors.white : (isDark ? Colors.white : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        appState.setMinRatingFilter(val ? 4.5 : 0.0);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Clear Filters'),
                      selected: false,
                      onSelected: (_) {
                        appState.resetFilters();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Popular Foods Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appState.selectedCategoryId == 'cat_all'
                          ? 'Popular Foods Near You'
                          : 'Food Results (${filteredFoods.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: onOpenSearch ?? () {},
                      child: const Text('SEE ALL'),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Food Items Grid
            filteredFoods.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No food items match the selected category & filter.',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final food = filteredFoods[index];
                          return FoodCard(
                            foodItem: food,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => FoodDetailScreen(foodItem: food),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filteredFoods.length,
                      ),
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
