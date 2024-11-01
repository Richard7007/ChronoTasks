import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do_list/build_text_button.dart';
import 'package:to_do_list/build_text_form_field_widget.dart';
import 'package:to_do_list/build_text_widget.dart';
import 'package:to_do_list/main.dart';

import 'home_page.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController otpController = TextEditingController();

  String? errorText;
  String isUserLogged ='isUserLogged';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(140, 0, 140, 0),
              child: Image.asset(
                'lib/asset/images/smartphone-icon-with-transparent-background-free-png.webp',
                color: Colors.cyan.shade400,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const BuildTextWidget(
              text: 'Verification',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const BuildTextWidget(
              text: 'You will get an OTP via SMS',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 58, right: 58, bottom: 20),
              child: BuildTextFormFieldWidget(
                controller: otpController,
                textAlign: TextAlign.center,
                readOnly: false,
                textInputType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintText: 'Enter OTP',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorText: errorText,
                ),
              ),
            ),
            SizedBox(
              width: 275,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const  SpinKitFadingFour(
                          color: Colors.cyan,
                        );
                      },
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      box?.put(isUserLogged,true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan.shade400),
                  shape: MaterialStateProperty.all(
                    BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const BuildTextWidget(
                  text: "Didn't receive an OTP?",
                  style: TextStyle(color: Colors.white),
                ),
                BuildTextButton(
                  text: "Resend OTP",
                  textColor: Colors.cyan.shade400,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
