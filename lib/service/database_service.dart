import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserExists(String phone) async {
    try {
      final snapshot = await _firestore.collection('users').doc(phone).get();
      return snapshot.exists;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
  Future<String?> addPersonDetails(Map<String, dynamic> personInfoMap, String? phone, String userType) async {
    try {
      await _firestore
          .collection(userType)
          .doc(phone)
          .set(personInfoMap);
    } catch (e) {
      //
    } return null;
  }
  Future<String?> uploadProfileImage(Uint8List profileImage, String username, String userType, String imageType) async {
    try {
      Uint8List compressedImage = await _compressImage(profileImage);
      final storageRef = FirebaseStorage.instance.ref().child('Images').child(userType).child(imageType).child('${username}_profile.jpg');
      final uploadTask = storageRef.putData(compressedImage);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      //
      return null;
    }
  }
  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    img.Image resizedImage = img.copyResize(image, width: 500);
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70);

    return Uint8List.fromList(compressedBytes);
  }
  static Future<void> fetchUserData(String phone, Function(UserModel?) onDataLoaded, Function(bool) onLoadingStateChanged) async {
    try {
      onLoadingStateChanged(true);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(phone).get();

      if (snapshot.exists) {
        UserModel? user = UserModel.fromMap(snapshot.data()!);
        onDataLoaded(user);
        print(snapshot.data());
      } else {
        onDataLoaded(null);
        print('Document does not exist');
      }
      onLoadingStateChanged(false);
    } catch (e) {
      onLoadingStateChanged(false);
      print('Error fetching user data: $e');
    }
  }
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.phoneNumber).update(user.toMap());
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
  static Future<List<String>> fetchStates() async {
    final snapshot = await FirebaseFirestore.instance.collection('crop_price').get();
    return snapshot.docs.map((doc) => doc['state'] as String).toSet().toList();
  }

  static Future<List<String>> fetchCities(String? state) async {
    if (state == null) return [];
    final snapshot = await FirebaseFirestore.instance.collection('crop_price').where('state', isEqualTo: state).get();
    return snapshot.docs.map((doc) => doc['city'] as String).toSet().toList();
  }

  static Future<List<String>> fetchCommodities(String? city) async {
    if (city == null) return [];
    final snapshot = await FirebaseFirestore.instance.collection('crop_price').where('city', isEqualTo: city).get();
    return snapshot.docs.map((doc) => doc['commodity'] as String).toSet().toList();
  }

  static Future<Map<String, dynamic>?> fetchCropPriceDetails(String state, String city, String commodity) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('crop_price')
        .where('state', isEqualTo: state)
        .where('city', isEqualTo: city)
        .where('commodity', isEqualTo: commodity)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  static Future<void> addDataToFirebase(String state, String city, String commodity, String price) async {
    await FirebaseFirestore.instance.collection('crop_price').add({
      'state': state,
      'city': city,
      'commodity': commodity,
      'price': price,
    });
  }

}
