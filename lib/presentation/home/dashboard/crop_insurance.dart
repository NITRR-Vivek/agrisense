import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';

class CropInsuranceScreen extends StatelessWidget {
  const CropInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Insurance'),
        backgroundColor: AppColors.darkAppColor200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPolicyInfoCard(),
            const SizedBox(height: 16),
            _buildTransactionHistoryCard(),
            const SizedBox(height: 16),
            _buildClaimStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insurance Policy Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Policy Number', 'ABC123456'),
            _buildInfoRow('Insured Crop', 'Wheat'),
            _buildInfoRow('Coverage Amount', '₹100,000'),
            _buildInfoRow('Policy Status', 'Active'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistoryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blockchain Transaction History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            const SizedBox(height: 16),
            _buildTransactionRow('Transaction ID', 'TXN001234567'),
            _buildTransactionRow('Date', '2024-07-15'),
            _buildTransactionRow('Amount', '₹50,000'),
            _buildTransactionRow('Status', 'Completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimStatusCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: AppColors.lightAppColor900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claim Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Claim ID', 'CLM987654'),
            _buildInfoRow('Status', 'Under Review'),
            _buildInfoRow('Claim Amount', '₹20,000'),
            _buildInfoRow('Expected Payout Date', '2024-08-01'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkAppColor300),
          ),
          Text(value),
        ],
      ),
    );
  }
}
