import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yumshare/features/discover/pages/discover_page.dart';
import 'package:yumshare/features/home/pages/home_page.dart';
import 'package:yumshare/features/myrecipe/pages/my_recipe_page.dart';
import 'package:yumshare/features/recipe/create_recipe/create_recipe_page.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

class Home extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  Home({super.key});

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      DiscoverPage(),
      CreateRecipePage(),
      MyRecipePage(),
      PlaceholderPage(title: 'Profile'),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      // Tab 1: My Recipes
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, size: 26),
        inactiveIcon: Icon(Icons.home, size: 26),
        title: "Home",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey[600]!,
      ),

      // Tab 2: Search
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search, size: 26),
        inactiveIcon: Icon(Icons.search_outlined, size: 26),
        title: "Discover",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey[600]!,
      ),

      // Tab 3: Add Recipe (Center FAB-style)
      PersistentBottomNavBarItem(
        icon: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
        title: "",
        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent,
      ),

      // Tab 4: Community
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu_book_outlined, size: 26),
        inactiveIcon: Icon(Icons.menu_book_outlined, size: 26),
        title: "My recipes",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey[600]!,
      ),

      // Tab 5: Profile
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_rounded, size: 26),
        inactiveIcon: Icon(Icons.person_outline_rounded, size: 26),
        title: "Profile",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey[600]!,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarItems(),
        navBarStyle: NavBarStyle.style15,
        navBarHeight: 50,
        handleAndroidBackButtonPress: true,
        stateManagement: true,
      ),
    );
  }
}

// Alternative: Style with labels only on active tab
List<PersistentBottomNavBarItem> _navBarItemsAlternative() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.menu_book_outlined, size: 26),
      title: "Recipes",
      activeColorPrimary: Colors.green[700]!,
      inactiveColorPrimary: Colors.grey[600]!,
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    PersistentBottomNavBarItem(
      icon: Icon(Icons.search_outlined, size: 26),
      title: "Search",
      activeColorPrimary: Colors.blue[700]!,
      inactiveColorPrimary: Colors.grey[600]!,
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    PersistentBottomNavBarItem(
      icon: CircleAvatar(
        backgroundColor: Colors.green[700]!,
        radius: 28,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      title: "",
    ),

    PersistentBottomNavBarItem(
      icon: Icon(Icons.people_outline, size: 26),
      title: "Community",
      activeColorPrimary: Colors.orange[700]!,
      inactiveColorPrimary: Colors.grey[600]!,
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    PersistentBottomNavBarItem(
      icon: Icon(Icons.person_outline, size: 26),
      title: "Profile",
      activeColorPrimary: Colors.purple[700]!,
      inactiveColorPrimary: Colors.grey[600]!,
      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  ];
}

// Widget tạm
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
      ),
    );
  }
}
