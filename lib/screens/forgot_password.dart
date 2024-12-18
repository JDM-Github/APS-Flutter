import 'dart:math';

import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/login.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCodeSent = false;

  String generateVerificationCode() {
    final random = Random();
    int verificationCode = 100000 + random.nextInt(900000);
    return verificationCode.toString();
  }

  String verificationCode = "";
  Future<void> sendEmail() async {
    if (emailController.text.isEmpty) return;
    RequestHandler requestHandler = RequestHandler();
    try {
      setState(() {
        verificationCode = generateVerificationCode();
      });

      String email = emailController.text;
      Map<String, dynamic> body = {
        "verificationCode": verificationCode,
        "email": email,
      };
      Map<String, dynamic> response = await requestHandler.handleRequest(context, 'send-email', body: body);
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Email sent successfully.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Loading sending email error'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: const Color.fromARGB(255, 80, 160, 170),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your email address to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                iconColor: const Color.fromARGB(255, 80, 160, 170),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCodeSent = true;
                  sendEmail();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reset code sent to ${emailController.text}')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Send Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            if (isCodeSent) ...[
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  hintText: 'Enter the code',
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text == confirmPasswordController.text &&
                      codeController.text == verificationCode) {
                    RequestHandler requestHandler = RequestHandler();
                    try {
                      Map<String, dynamic> response = await requestHandler.handleRequest(
                        context,
                        'users/change-password',
                        body: {
                          'email': emailController.text,
                          'password': passwordController.text,
                        },
                      );

                      if (response['success'] == true) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Password reset successfully!')),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'] ?? 'Forgot password failed')),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred: $e')),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 100)
            ],
          ],
        ),
      ),
    );
  }
}
