class SignupData {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phoneNumber;
  String? countryCode;
  String? gender;
  DateTime? dob;

  // Step 2
  String? country;
  String? city;

  // Step 3
  String? experienceLevel;
  List<String> activities = [];

  // Step 4
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? relationship;

  // Step 5
  String? bio;
  String? profileFile;

  // Step 6
  bool? agreedToTerms;
  bool? subscribeUpdates;

  SignupData({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phoneNumber,
    this.countryCode,
    this.gender,
    this.dob,
  });
}