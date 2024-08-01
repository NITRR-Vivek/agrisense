import 'package:agrisense/presentation/shop_screen/orders.dart';
import 'package:agrisense/presentation/shop_screen/shop.dart';
import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          title: const Text(
            "Market place",
            style: TextStyle(
              color: Color(0xFF5A8BBC),
              fontFamily: 'PoppinsBold',
            ),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _onButtonPressed(0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 0 ? AppColors.darkAppColor400 : AppColors.lightAppColor700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                        width: 1,
                      ),
                      minimumSize: const Size(180, 35),
                      elevation: 4,
                    ),
                    child: Text(
                      "Shop",
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _onButtonPressed(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 1 ? AppColors.darkAppColor400 : AppColors.lightAppColor700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                        width: 1,
                      ),
                      minimumSize: const Size(180, 35),
                      elevation: 4,
                    ),
                    child: Text(
                      "Orders",
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ShopScreen(),
          OrdersScreen(),
        ],
      ),

    );
  }
}
