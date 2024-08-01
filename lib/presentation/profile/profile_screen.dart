import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/user_model.dart';
import '../../service/database_service.dart';
import '../../utils/constants.dart';
import '../../utils/shared_preference_helper_id.dart';
import '../splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  bool _isLoadingImage = false; // Image loading state
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    _getUserDataFromSharedPreferences();
  }

  Future<void> _getUserDataFromSharedPreferences() async {
    final String? storedPhone = await SharedPreferencesHelperID.getPhone();

    if (storedPhone != null) {
      setState(() {
        userPhone = storedPhone;
      });
    }
    DatabaseService.fetchUserData(userPhone, _onUserDataLoaded, _onLoadingStateChanged); // Fetch user data
  }

  void _onUserDataLoaded(UserModel? user) {
    setState(() {
      _user = user;
    });
  }

  void _onLoadingStateChanged(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildEditProfileBottomSheet(),
    );
  }

  Widget _buildEditProfileBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Take Photo'),
            onTap: () {
              _getImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              _getImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          if (_user != null && _user!.profileImage != null) ...[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Remove Current Photo'),
              onTap: () {
                setState(() {
                  _user!.profileImage = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _isLoadingImage = true; // Start image loading indicator
      });
      await _uploadProfileImage(File(pickedFile.path));
      setState(() {
        _isLoadingImage = false; // Stop image loading indicator
      });
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String? userId = _user!.phoneNumber;
      final String fileName = '${userId}_profile.jpg';

      final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child(fileName);
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL from the snapshot
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _user!.profileImage = downloadUrl;
        _isLoading = false; // Stop loading indicator
      });

      // Optionally, you can update the profile image URL in Firestore if needed
      await DatabaseService().updateUserData(_user!);
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading indicator
        _isLoadingImage = false; // Stop image loading indicator in case of error
      });
      print('Error uploading profile image: $e');
      // Handle error appropriately
    }
  }

  void _editUserDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildEditUserDetailsBottomSheet(),
    );
  }

  Widget _buildEditUserDetailsBottomSheet() {
    TextEditingController nameController = TextEditingController(text: _user?.name ?? '');
    TextEditingController dobController = TextEditingController(text: _user?.dob ?? '');
    TextEditingController genderController = TextEditingController(text: _user?.gender ?? '');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Edit Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: dobController,
            decoration: InputDecoration(labelText: 'Date of Birth'),
          ),
          TextField(
            controller: genderController,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_user != null) {
                _user!.name = nameController.text;
                _user!.dob = dobController.text;
                _user!.gender = genderController.text;
                await DatabaseService().updateUserData(_user!);
                Navigator.pop(context); // Close bottom sheet
                setState(() {}); // Refresh UI
              }
            },
            child: const Text('Submit', style: TextStyle(color: AppColors.darkAppColor300)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen', style: TextStyle(
          color: AppColors.darkAppColor300,
          fontWeight: FontWeight.bold,
        )),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: _editProfile,
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Image.asset(
              'assets/images/prof_back.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: _isLoading ? _buildShimmer() : _buildProfile(),
          ),
        ],
      ),
      bottomNavigationBar: _buildLogoutButton(),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(width: 100, height: 20, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: 150, height: 20, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: 200, height: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    if (_user == null) {
      return const Center(child: Text('No user data available'));
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  _isLoadingImage ? _buildImageShimmer() : _buildProfileImage(),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.darkAppColor400),
                      onPressed: _editProfile,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${_user!.name ?? 'N/A'}',style: const TextStyle(fontSize: 18),),
                        const SizedBox(height: 10),
                        Text('Date of Birth: ${_user!.dob ?? 'N/A'}',style: const TextStyle(fontSize: 18),),
                        const SizedBox(height: 10),
                        Text('Gender: ${_user!.gender ?? 'N/A'}',style: const TextStyle(fontSize: 18),),
                        const SizedBox(height: 10),
                        Text('Phone Number: ${_user!.phoneNumber ?? 'N/A'}',style: const TextStyle(fontSize: 18),),
                        const SizedBox(height: 10),
                        Text('Address: ${_user?.streetAddress}, ${_user?.city}, ${_user?.district}, ${_user?.state}',style: const TextStyle(fontSize: 18),),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit,color: AppColors.darkAppColor400,),
                      onPressed: _editUserDetails,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey[300],
          ),
          child: _user!.profileImage != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/user_icon.png'),
              image: NetworkImage(_user!.profileImage!),
              fit: BoxFit.cover,
              width: 300,
              height: 300,
              imageErrorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
          )
              : Center(
            child: Icon(Icons.person, size: 50, color: Colors.grey[800]),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfile,
          ),
        ),
      ],
    );
  }


  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _logout();
        },
        child: const Text('Logout', style: TextStyle(color: AppColors.darkAppColor300)),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await SharedPreferencesHelperID.setLoggedIn(false);
      await SharedPreferencesHelperID.setPhone("");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
      );
      await Future.delayed(Duration.zero);
      await SystemNavigator.pop();
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
