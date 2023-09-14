import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/model/custom_user.dart';
import 'package:tmdb_app/view/screens/home_screen.dart';
import 'package:tmdb_app/view/screens/sign_up/sign_up.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    if (user == null) {
      return  const SignUp();
    } else {
      return HomeScreen();
    }
  }
}
