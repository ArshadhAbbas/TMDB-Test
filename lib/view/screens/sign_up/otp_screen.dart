// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tmdb_app/view/screens/home_screen.dart';
import 'package:tmdb_app/view/screens/sign_up/sign_up.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;
  var smsCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ))),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Image.asset('assets/Mobile-login.jpeg',
                    width: MediaQuery.of(context).size.width * 0.8),
                const Text(
                  "Verify Number",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "An OTP has sent to your number.Put it down below",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Pinput(
                  onChanged: (value) {
                    smsCode = value;
                  },
                  autofocus: true,
                  length: 6,
                  showCursor: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: SignUp.verify,
                                  smsCode: smsCode);
                          await auth.signInWithCredential(credential);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      child: const Text("Verify OTP")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
