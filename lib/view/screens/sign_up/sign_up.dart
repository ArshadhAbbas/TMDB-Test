import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_app/view/screens/sign_up/otp_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String verify = '';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController countryCode = TextEditingController();
  @override
  void initState() {
    countryCode.text = "+91";
    super.initState();
  }

  var phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We need to register your phone before we start !",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: countryCode,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      const Text(
                        "|",
                        style: TextStyle(
                            fontSize: 33, color: Color.fromARGB(99, 0, 0, 0)),
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone number"),
                        ),
                      ),
                    ],
                  ),
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
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: countryCode.text + phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              SignUp.verify = verificationId;
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OtpScreen(),
                              ));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      child: const Text("Send the Code")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
