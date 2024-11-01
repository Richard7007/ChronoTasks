import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/utils/hive.dart';
import 'package:to_do_list/verification_page.dart';
import 'package:to_do_list/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String isLogged = 'isLogged';

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        await _saveUser(auth.currentUser!, phoneNumber);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          // ignore_for_file: avoid_print
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = '';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await auth.signInWithCredential(credential);
        await _saveUser(auth.currentUser!, phoneNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationPage(),
          ),
        );
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _saveUser(User user, String phoneNumber) async {
    final box = await Hive.openBox('phoneNumber');
    String extractedPhoneNumber = phoneNumber.substring(3);
    await box.put('phoneNumber', extractedPhoneNumber);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 48,
            ),
            const Text(
              'Create new Account',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have account?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 75,
              width: 340,
              child: Padding(
                padding: const EdgeInsets.only(left: 33, right: 35, bottom: 20),
                child: TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number',
                    hintStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 275,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _verifyPhoneNumber(_phoneNumberController.text);
                        await Future.delayed(const Duration(seconds: 3));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerificationPage(),
                            ));
                      },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.cyan.shade400),
                ),
                child: _isLoading
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25,
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    indent: 90,
                  ),
                ),
                Text(
                  '  OR  ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Divider(
                    endIndent: 90,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 275,
              child: ElevatedButton(
                onPressed: _isGoogleLoading
                    ? null
                    : () async {
                        setState(() {
                          _isGoogleLoading = true;
                        });
                        await signInWithGoogle();
                        setState(() {
                          _isGoogleLoading = false;
                        });
                        AppHive().putIsLogged(value: true);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Colors.cyan),
                ),
                child: _isGoogleLoading
                    ? const SpinKitThreeBounce(
                        color: Colors.cyan,
                        size: 25,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            child:
                                Image.asset('lib/asset/images/google logo.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Sign in with Google'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
