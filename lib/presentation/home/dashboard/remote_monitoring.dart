import 'package:flutter/material.dart';

class RemoteMonitoringScreen extends StatelessWidget {
  const RemoteMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Monitoring Dashboard'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Image with Loader
            const Text("Your Farm",style: TextStyle(fontWeight: FontWeight.bold),),
            _buildFarmImage(),
            const SizedBox(height: 16),
            _buildSectionTitle('Soil Sensors'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Soil Moisture Level',
              value: '45%',
              icon: Icons.water_drop,
            ),
            _buildInfoCard(
              title: 'Soil pH',
              value: '6.2',
              icon: Icons.local_activity,
            ),
            _buildInfoCard(
              title: 'Soil Temperature',
              value: '22°C',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Weather Sensors'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Ambient Temperature',
              value: '28°C',
              icon: Icons.thermostat_outlined,
            ),
            _buildInfoCard(
              title: 'Humidity Level',
              value: '60%',
              icon: Icons.invert_colors,
            ),
            _buildInfoCard(
              title: 'Rainfall',
              value: '10 mm',
              icon: Icons.cloud_outlined,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Irrigation System'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Current Status',
              value: 'Active',
              icon: Icons.water,
            ),
            _buildInfoCard(
              title: 'Next Scheduled Watering',
              value: '2 hours',
              icon: Icons.timer,
            ),
            _buildInfoCard(
              title: 'Water Usage Today',
              value: '500 liters',
              icon: Icons.opacity,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Crop Management'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Growth Stage',
              value: '70% maturity',
              icon: Icons.leak_add,
            ),
            _buildInfoCard(
              title: 'Pest Detection',
              value: 'No pests detected',
              icon: Icons.security,
            ),
            _buildInfoCard(
              title: 'Fertilizer Status',
              value: 'Applied 3 days ago',
              icon: Icons.add_moderator_outlined,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Equipment Status'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Tractor',
              value: 'Operational',
              icon: Icons.engineering,
            ),
            _buildInfoCard(
              title: 'Plow',
              value: 'Needs maintenance',
              icon: Icons.build,
            ),
            _buildInfoCard(
              title: 'Sprayer',
              value: 'Operational',
              icon: Icons.water_drop,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Livestock Monitoring'),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Health Status',
              value: 'All livestock healthy',
              icon: Icons.pets,
            ),
            _buildInfoCard(
              title: 'Feeding Schedule',
              value: 'Next feed in 2 hours',
              icon: Icons.fastfood,
            ),
            _buildInfoCard(
              title: 'Water Intake',
              value: '20 liters per animal',
              icon: Icons.water,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmImage() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Center(child: CircularProgressIndicator()),
            Image.network(
              'https://indiasomeday.com/wp-content/uploads/2020/07/krishna-ranch.jpg', // Replace with your image URL
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, color: Colors.red));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
