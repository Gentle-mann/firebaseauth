import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/data/user_dao.dart';
import 'package:login_page/pages/email_verification.dart';
import 'package:login_page/pages/home.dart';
import 'package:login_page/pages/register.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome back!",
                  style: GoogleFonts.fasthand(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email field cannot be empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.email_rounded),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      //height: 50,
                      child: TextFormField(
                        controller: _passwordController,
                        autofocus: false,
                        obscureText: isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        autocorrect: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Password field cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "........",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: _rememberMe,
                          onChanged: (newValue) {
                            setState(() {
                              _rememberMe = newValue!;
                            });
                          },
                        ),
                        const Text(
                          "Remember me",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _emailController.text;
                        final errorMessage =
                            await userDao.sendPasswordResetLink(email);
                        if (errorMessage != null) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'A password-reset email has been sent to your email'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValid = _formKey.currentState!.validate();
                      FocusScope.of(context).unfocus();
                      if (isValid) {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        final errorMessage =
                            await userDao.login(email, password);
                        if (errorMessage != null) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              duration: const Duration(
                                seconds: 3,
                              ),
                            ),
                          );
                        } else if (userDao.isEmailVerified()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                          );
                        } else if (userDao.isLoggedIn() &&
                            !userDao.isEmailVerified()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EmailVerificationScreen(
                                    isNewUser: false,
                                    email: userDao.getEmail());
                              },
                            ),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: const Text("Sign In"),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/images/google1.png',
                              fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Sign In with Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const RegisterPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
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
