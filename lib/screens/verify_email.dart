import 'dart:math';

import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/admin_dashboard.dart';
import 'package:first_project/screens/employee_dashboard.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  final bool isAdmin;
  const VerifyEmail(
    this.email, {
    super.key,
    this.isAdmin = false,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController codeController = TextEditingController();

  bool isCodeSent = false;

  String generateVerificationCode() {
    final random = Random();
    int verificationCode = 100000 + random.nextInt(900000);
    return verificationCode.toString();
  }

  String verificationCode = "";
  Future<void> sendEmail() async {
    if (widget.email.isEmpty) return;
    RequestHandler requestHandler = RequestHandler();
    try {
      setState(() {
        verificationCode = generateVerificationCode();
      });

      String email = widget.email;
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

  Future<void> verifyEmail() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/verify-email',
        body: {
          'email': widget.email,
        },
      );

      if (response['success'] == true) {
        if (mounted) {
          Navigator.pop(context);
          if (widget.isAdmin) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (builder) => const AdminDashboardScreen()),
            //   );
            // } else {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (builder) => const DashboardScreen()),
            //   );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account email has been verified successfully!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Account email verification failed')),
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
        title: Text('Verify Email Account'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: TextEditingController(text: widget.email),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                iconColor: const Color.fromARGB(255, 80, 160, 170),
              ),
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCodeSent = true;
                  sendEmail();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Verification code sent to ${widget.email}')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Send Verification Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
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
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (codeController.text == verificationCode) {
                    verifyEmail();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Wrong Verification Code')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Verify Email Account',
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
