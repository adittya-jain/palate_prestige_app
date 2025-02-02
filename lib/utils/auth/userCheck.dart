import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:palate_prestige/screens/home_screen.dart';
import 'package:palate_prestige/widgets/loader.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Male'; // Default gender selection
  bool _isLoading = true;

  // Firebase user data
  User? user;

  @override
  void initState() {
    super.initState();
    // Get current user
    user = FirebaseAuth.instance.currentUser;
    _checkIfUserExists();
  }

  // Check if user exists in Firestore

  Future<void> _checkIfUserExists() async {
    if (user == null) {
      setState(() {
        _isLoading = false; // Stop loader if no user
      });
      return;
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (userDoc.exists) {
      // If user exists, navigate to the HomeScreen
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/homePage');
    } else {
      setState(() {
        _isLoading = false; // Stop loader if no user
      });
    }
  }

  // Validate phone number
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  // Store data in Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': user!.displayName,
        'email': user!.email,
        'phone': _phoneController.text,
        'gender': _selectedGender,
      });
      // Navigate to the home page after storing data
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/homePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    //Animation :)
                    const SizedBox(
                      height: 300,
                      width: 300,
                      child: LottieLoader(url: 'assets/userLoading.json'),
                    ),

                    const SizedBox(height: 16),
                    //Hi, Aditya Text
                    Center(
                      child: Text(
                        'Hi, ${user?.displayName?.split(' ')[0] ?? 'Fella'}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Name (non-editable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Padding on left and right
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            60, 104, 104, 104), // White background
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          initialValue: user?.displayName ?? '',
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none, // Remove default border
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Padding on left and right
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            60, 104, 104, 104), // White background
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          initialValue: user?.email ?? '',
                          decoration: const InputDecoration(
                              labelText: 'Email', border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Padding on left and right
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            60, 104, 104, 104), // White background
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: InputBorder.none),
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Padding on left and right
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            60, 104, 104, 104), // White background
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                              labelText: 'Gender', border: InputBorder.none),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                          items: <String>['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: 100, // Specify the button width
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange[600], // Orange button color
                            foregroundColor: Colors.white, // White text color
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0), // Adjust padding
                            textStyle: const TextStyle(
                              fontSize: 16.0, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                            ),
                          ),
                          child: const Text('Submit'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
