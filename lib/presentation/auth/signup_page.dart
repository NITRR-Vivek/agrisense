import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../service/database_service.dart';
import '../../utils/constants.dart';
import '../../utils/pick_image.dart';
import '../home_screen.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/gender_selector.dart';
import '../widgets/google_maps_screens/google_map.dart';

class SignupScreen extends StatefulWidget {
  final String phone;
  const SignupScreen( {super.key,required this.phone});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';
  bool _isLoading = false;
  Uint8List? _profileImage;
  LatLng latLong = const LatLng(21.25, 81.6052);

  final Map<String, String> formData = {};
  bool scanning = false;
  List<double> coordinates = [0.0, 0.0];
  Placemark place = const Placemark();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  DatabaseService databaseService = DatabaseService();

  void _pickImage(ImageSource source) async {
    Uint8List? pickedImage = await pickImage(source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  void _submitForm() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserModel user = UserModel(
        name: formData['name'],
        phoneNumber: formData['phone'],
        email: formData['email'],
        gender: selectedGender,
        streetAddress: formData['streetAddress'],
        village: formData['village'],
        city: formData['city'],
        district: formData['district'],
        state: formData['state'],
        pin: formData['pin'],
        coordinates: [
          coordinates[0],
          coordinates[1],
        ],
      );

      if (_profileImage != null) {
        String? profileImageUrl = await databaseService.uploadProfileImage(
          _profileImage!,
          widget.phone,
          "Farmers",
          "Profile_Images",
        );
        user.profileImage = profileImageUrl;
      }

      await databaseService.addPersonDetails(user.toMap(), widget.phone, "users").then((value) {
        CustomSnackbar.show(context, message: "Account successfully created!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
        );
      }).catchError((error) {
        CustomSnackbar.show(context, message: "Failed to create account. Please try again.");
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showLocationPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Permission"),
          content: const Text("This app collects your location data to enable the feature and provide better service."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                checkPermission();
                },
              child: const Text("Allow",style: TextStyle(color: AppColors.primaryColor)),),

          ],
        );
      },
    );
  }

  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackbar.show(context, message: "Location Permission Denied!");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CustomSnackbar.show(context, message: "Location Permission Denied Forever!");
      return;
    }
    getLocation(context);
  }

  Future<void> getLocation(BuildContext context) async {
    setState(() {
      scanning = true;
    });
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      coordinates = [position.latitude, position.longitude];
      List<Placemark> result = await placemarkFromCoordinates(position.latitude, position.longitude);
      place = result[0];
      setState(() {
        _streetAddressController.text = place.street ?? '';
        _villageController.text = place.subLocality ?? '';
        _cityController.text = place.locality ?? '';
        _districtController.text = place.subAdministrativeArea ?? '';
        _stateController.text = place.administrativeArea ?? '';
        _pinController.text = place.postalCode ?? '';
      });
    } catch (e) {
      CustomSnackbar.show(context, message: e.toString());
    }
    setState(() {
      scanning = false;
    });
  }
  void _openGoogleMap() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapWidget(
          initialPosition: latLong,
        ),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        scanning = true;
        coordinates = [pickedLocation.latitude, pickedLocation.longitude];
        latLong = pickedLocation;
      });
      await _getAddressFromCoordinates(pickedLocation.latitude, pickedLocation.longitude);
      setState(() {
        scanning = false;
      });
    }
  }
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> result = await placemarkFromCoordinates(latitude, longitude);
      place = result[0];
      setState(() {
        _streetAddressController.text = place.street ?? '';
        _villageController.text = place.subLocality ?? '';
        _cityController.text = place.locality ?? '';
        _districtController.text = place.subAdministrativeArea ?? '';
        _stateController.text = place.administrativeArea ?? '';
        _pinController.text = place.postalCode ?? '';
      });
    } catch (e) {
      CustomSnackbar.show(context, message: e.toString());
    }
  }

  @override
  void initState() {
    _showLocationPermissionDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.grey.shade800)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 50,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo, color: Colors.blue, size: 20),
                        onPressed: () {
                          _showImageSourceActionSheet(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(labelText: 'Name*', fieldKey: 'name', formData: formData),
                CustomTextField(labelText: 'Phone Number*', fieldKey: 'phone', initialValue: widget.phone, readOnly: true, formData: formData),
                CustomTextField(labelText: 'Email*', fieldKey: 'email', inputType: TextInputType.emailAddress, formData: formData),
                GenderSelector(
                  selectedGender: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10,),
                const Text("Enter your Address",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      text:"Location from Map",
                      buttonTextStyle: const TextStyle(fontSize: 10,color: Colors.white),
                      width: 160,
                      height: 40,
                      onPressed: _openGoogleMap,),
                    CustomElevatedButton(
                      width: 160,
                      height: 40,
                      text: "Get current Location",
                      buttonTextStyle: const TextStyle(fontSize: 10,color: Colors.white),
                      onPressed: _showLocationPermissionDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                scanning
                    ? const SpinKitRipple(color: AppColors.darkAppColor300, size: 100)
                    : Column(
                  children: [
                    CustomTextField(labelText: 'Street Address', fieldKey: 'streetAddress', formData: formData, controller: _streetAddressController),
                    CustomTextField(labelText: 'Village', fieldKey: 'village', formData: formData, controller: _villageController),
                    CustomTextField(labelText: 'City', fieldKey: 'city', formData: formData, controller: _cityController),
                    CustomTextField(labelText: 'District', fieldKey: 'district', formData: formData, controller: _districtController),
                    CustomTextField(labelText: 'State', fieldKey: 'state', formData: formData, controller: _stateController),
                    CustomTextField(labelText: 'Pin', fieldKey: 'pin', formData: formData, controller: _pinController),
                  ],
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () {
                    if (!_isLoading) {
                      _submitForm();
                    }
                  },
                  text: 'Create Account',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}