import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:palate_prestige/screens/home_screen.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Male';  // Default gender selection

  // Firebase user data
  User? user;

  @override
  void initState() {
    super.initState();
    // Get current user
    user = FirebaseAuth.instance.currentUser;
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
    // DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc();
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'cust_id': user!.uid,
        'name': user!.displayName,
        'email': user!.email,
        'phone': _phoneController.text,
        'gender': _selectedGender,
      });
      // Navigate to the home page after storing data

      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name (non-editable)
              TextFormField(
                initialValue: user?.displayName ?? '',
                decoration: const InputDecoration(labelText: 'Name'),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Email (non-editable)
              TextFormField(
                initialValue: user?.email ?? '',
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Phone number with validation
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
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
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
