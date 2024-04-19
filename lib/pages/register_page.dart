import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_ticket_app/components/my_button.dart';
import 'package:parking_ticket_app/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ownerNameController = TextEditingController();
  final carNumberPlateController = TextEditingController();
  final carBrandController = TextEditingController();

  //Sign User Up Method
  void signUserUp() async {
    //Show Loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //try sign up
    try {
      //Check confirm password and password are same
      if (passwordController.text == confirmPasswordController.text) {
        //Authenticate user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //Add user details
        addUserDetails(
          emailController.text.trim(),
          ownerNameController.text.trim(),
          carNumberPlateController.text.trim().toUpperCase(),
          carBrandController.text.trim().toUpperCase(),
        );
      } else {
        //Show error message
        showErrorMessage('Passowrd don\'t match');
      }
      //pop loading circle
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      if (mounted) {
        Navigator.pop(context);
      }
      //Wrong Email
      if (e.code == 'channel-error') {
        showErrorMessage('Invalid Email');
      }
      //Wrong Password
      else if (e.code == 'invalid-credential') {
        showErrorMessage('Invalid Password');
      }
    }
  }

  Future addUserDetails(
    String email,
    String ownerName,
    String carNumberPlate,
    String carBrand,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'Email': email,
      'Owner Name': ownerName,
      'Car Number Plate': carNumberPlate,
      'Car Brand': carBrand,
    });
  }

  //Error message

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                //LOGO
                Icon(
                  Icons.lock,
                  size: 50,
                ),
                SizedBox(height: 25),
                //Welcome back
                Text(
                  "Lets Make an account for you",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                SizedBox(height: 25),
                //Owner Name
                MyTextField(
                  controller: ownerNameController,
                  hintText: 'Car Owner Name',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                //Car Number Plate
                MyTextField(
                  controller: carNumberPlateController,
                  hintText: 'Car Number Plate',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                //Car Brand
                MyTextField(
                  controller: carBrandController,
                  hintText: 'Car Brand',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                //Username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                //Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 10),
                //Confirm Password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                //Forgot
                SizedBox(height: 25),
                //Sign in
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
                ),
                SizedBox(height: 50),

                //Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a Member?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
