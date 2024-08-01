class UserModel {
  late final String? name;
  final String? phoneNumber;
  final String? email;
  late final String? gender;
  late final String? dob;
  final String? state;
  final String? streetAddress;
  final String? village;
  final String? city;
  final String? district;
  final String? pin;
  final List<dynamic>? coordinates;
  String? profileImage;

  UserModel({
    this.name,
    this.phoneNumber,
    this.email,
    this.gender,
    this.dob,
    this.state,
    this.streetAddress,
    this.village,
    this.city,
    this.district,
    this.pin,
    this.coordinates,
    this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    try {
      return UserModel(
        name: data['Name'],
        phoneNumber: data['Phone Number'],
        email: data['Email'],
        gender: data['Gender'],
        dob: data['DoB'],
        state: data['State'],
        streetAddress: data['Street Address'],
        village: data['Village'],
        city: data['City'],
        district: data['District'],
        pin: data['Pin'],
        coordinates: data['Co-Ordinates'] != null
            ? [data['Co-Ordinates'][0], data['Co-Ordinates'][1]] // Assuming Co-Ordinates is an array [latitude, longitude]
            : null,
        profileImage: data['Profile Image'],
      );
    } catch (e) {
      print('Error parsing UserModel: $e');
      return UserModel(); // Return a default or handle error case appropriately
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> userMap = {
      'Name': name,
      'Phone Number': phoneNumber,
      'Email': email,
      'Gender': gender,
      'DoB': dob,
      'State': state,
      'Street Address': streetAddress,
      'Village': village,
      'City': city,
      'District': district,
      'Pin': pin,
      'Co-Ordinates': coordinates != null && coordinates!.isNotEmpty
          ? [coordinates![0], coordinates![1]] // Assuming coordinates is an array [latitude, longitude]
          : null,
      'Profile Image': profileImage,
    };

    userMap.removeWhere((key, value) => value == null || value == '' || (value is List && value.isEmpty));

    return userMap;
  }
}
