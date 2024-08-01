import 'package:agrisense/presentation/profile/profile_screen.dart';
import 'package:agrisense/presentation/shop_screen/market_place.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../utils/constants.dart';
import 'ai_tools/ai_tools_fab.dart';
import 'home/dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const DashboardScreen(),
      AIToolsScreen(),
      const MarketScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard),
        title: "Dashboard",
        activeColorPrimary: AppColors.darkAppColor300,
        inactiveColorPrimary: AppColors.lightAppColor500,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.construction),
        title: "AI Tools",
        activeColorPrimary: AppColors.darkAppColor300,
        inactiveColorPrimary: AppColors.lightAppColor500,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shop),
        title: "Shop",
        activeColorPrimary: AppColors.darkAppColor300,
        inactiveColorPrimary: AppColors.lightAppColor500,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: AppColors.darkAppColor300,
        inactiveColorPrimary: AppColors.lightAppColor500,
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
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style3,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
