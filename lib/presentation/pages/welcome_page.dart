import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_pals/app_state.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/src/authentication.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 1. Header Text
              Text(
                'WELCOME\nBACK.',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  height: 1.1,
                  letterSpacing: -1.0,
                ),
              ),

              const Spacer(flex: 2),

              // 2. Illustration
              Center(
                child: SvgPicture.asset(
                  'assets/images/Login_page_image.svg',
                  height: 500,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 3),

              Center(
                child: Consumer<ApplicationState>(
                  builder: (context, appState, _) => AuthFunc(
                    loggedIn: appState.loggedIn,
                    signOut: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
