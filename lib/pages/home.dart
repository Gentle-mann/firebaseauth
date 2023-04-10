import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/user_dao.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () {
              userDao.logout();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nothing to see here...yet!',
                style: GoogleFonts.amiriQuran(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
