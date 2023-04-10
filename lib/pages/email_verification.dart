import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/user_dao.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final bool isNewUser;

  const EmailVerificationScreen(
      {required this.isNewUser, required this.email, super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification link has been sent to ${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Please check your email and click on the verification link to complete the sign up process. (Check your spam label if you can\'t find the email)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            if (widget.isNewUser)
              isButtonClicked
                  ? const Text(
                      'Verification link sent:]',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          isButtonClicked = true;
                        });
                        userDao.sendEmailVerification();
                      },
                      child: const Text(
                        'Resend verification email',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
