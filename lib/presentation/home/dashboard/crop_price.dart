import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../../service/database_service.dart';

class CropPriceScreen extends StatefulWidget {
  const CropPriceScreen({super.key});

  @override
  _CropPriceScreenState createState() => _CropPriceScreenState();
}

class _CropPriceScreenState extends State<CropPriceScreen> {
  String? selectedState;
  String? selectedCity;
  String? selectedCommodity;
  Map<String, dynamic>? cropPriceDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Price'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown('Select State', DatabaseService.fetchStates(), (value) {
              setState(() {
                selectedState = value;
                selectedCity = null;
                selectedCommodity = null;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Select City', DatabaseService.fetchCities(selectedState), (value) {
              setState(() {
                selectedCity = value;
                selectedCommodity = null;
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown('Select Commodity', DatabaseService.fetchCommodities(selectedCity), (value) {
              setState(() {
                selectedCommodity = value;
              });
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCropPriceDetails,
              child: const Text('Get Price',style: TextStyle(color: AppColors.darkAppColor300),),
            ),
            const SizedBox(height: 16),
            if (cropPriceDetails != null) _buildPriceCard(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddDataBottomSheet(context);
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildDropdown(String hint, Future<List<String>> itemsFuture, ValueChanged<String?> onChanged) {
    return FutureBuilder<List<String>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return DropdownButton<String>(
          hint: Text(hint,style: TextStyle(color: AppColors.lightAppColor600),),
          value: hint == 'Select State' ? selectedState : hint == 'Select City' ? selectedCity : selectedCommodity,
          items: snapshot.data!.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
        );
      },
    );
  }

  Widget _buildPriceCard() {
    return Card(
      color: AppColors.lightAppColor800,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('${DateTime.now().toLocal().toString().split(' ')[0]}'),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('State:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(cropPriceDetails!['state']),
                ),
              ],
            ),
            const SizedBox(height: 8), // Add some spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('City:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(cropPriceDetails!['city']),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Commodity:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(cropPriceDetails!['commodity']),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('₹ ${cropPriceDetails!['price']}'),
                ),
              ],
            ),
          ],
        )

      ),
    );
  }

  Future<void> _fetchCropPriceDetails() async {
    if (selectedState != null && selectedCity != null && selectedCommodity != null) {
      final details = await DatabaseService.fetchCropPriceDetails(selectedState!, selectedCity!, selectedCommodity!);
      if (details != null) {
        setState(() {
          cropPriceDetails = details;
        });
      } else {
        _showAlertDialog('No data found for the selected commodity.');
      }
    } else {
      _showAlertDialog('Please select state, city, and commodity.');
    }
  }

  void _showAddDataBottomSheet(BuildContext context) {
    final TextEditingController stateController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController commodityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: commodityController,
                  decoration: const InputDecoration(labelText: 'Commodity'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    DatabaseService.addDataToFirebase(
                      stateController.text,
                      cityController.text,
                      commodityController.text,
                      priceController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Add Data'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: AppColors.lightAppColor800,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
