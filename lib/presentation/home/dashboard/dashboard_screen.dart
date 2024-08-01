import 'package:agrisense/presentation/home/dashboard/remote_monitoring.dart';
import 'package:agrisense/presentation/home/dashboard/soil_info.dart';
import 'package:agrisense/presentation/home/dashboard/weather_section.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar_home.dart';
import 'blog_details.dart';
import 'crop_insurance.dart';
import 'crop_price.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final GlobalKey<WeatherSectionState> _weatherKey = GlobalKey<WeatherSectionState>();
  Future<void> _fetchWeather() async {
    _weatherKey.currentState?.refreshWeather();
  }
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(),
      body: RefreshIndicator(
        onRefresh: _fetchWeather,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeatherSection(key: _weatherKey),
                const SizedBox(height: 16,),
                const Text(
                  'Services',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildServiceCard(
                      context,
                      'Remote Monitoring',
                      'assets/images/remote_crops.jpg',
                      const RemoteMonitoringScreen(),
                    ),
                    _buildServiceCard(
                      context,
                      'Soil Info',
                      'assets/images/soil_info.jpg',
                      const SoilInfoScreen(),
                    ),
                    _buildServiceCard(
                      context,
                      'Crop Price',
                      'assets/images/crop_price.jpg',
                      const CropPriceScreen(),
                    ),
                    _buildServiceCard(
                      context,
                      'Crop Insurance',
                      'assets/images/crop_insurance.jpg',
                      const CropInsuranceScreen(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Blogs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildBlogCard(
                          context,
                          'Understanding Soil Health',
                          'Learn how to maintain healthy soil for better crop yields.',
                          'assets/images/soil_health.jpeg',
                          'Detailed blog content about soil health...',
                        ),
                        _buildBlogCard(
                          context,
                          'Effective Water Management',
                          'Strategies to conserve water and improve irrigation efficiency.',
                          'assets/images/water_management.jpeg',
                          'Detailed blog content about water management...',
                        ),
                        _buildBlogCard(
                          context,
                          'Sustainable Agriculture Practices',
                          'Implementing sustainable farming techniques.',
                          'assets/images/sus_agri2.jpeg',
                          'Detailed blog content about sustainable agriculture...',
                        ),
                        _buildBlogCard(
                          context,
                          'Organic Farming Benefits',
                          'Exploring the advantages of organic farming.',
                          'assets/images/organic.jpeg',
                          'Detailed blog content about organic farming...',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String imagePath, Widget screen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.9),
              BlendMode.dstATop,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to the respective service screen
            _navigateToScreen(context, screen);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  backgroundColor: Colors.black38,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, String title, String description, String imagePath, String content) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to the BlogDetails screen
            _navigateToScreen(context, BlogDetailsScreen(title: title, content: content));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    backgroundColor: Colors.black38,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    backgroundColor: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
