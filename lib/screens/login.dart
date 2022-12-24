import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  String phNumber = "";
  String phOtp = "";

  bool isChecked = false;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Container(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      print(e.message);
    }
  }

  getMobileFormWidget(context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),
              Row(
                children: const [
                  Text("Truckcopy", style: TextStyle(fontSize: 36)),
                  Spacer()
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                  "Suspendisse cras et amet, ornare et donec tellus pellentesque. ",
                  style: TextStyle(fontSize: 16)),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(50, 0, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    setState(() {
                      phNumber = number.phoneNumber!;
                    });
                    print(phNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: phoneController,
                  formatInput: false,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  onSaved: (PhoneNumber number) {
                    setState(() {
                      phNumber = number.phoneNumber!;
                    });
                    print('On Saved: $phNumber');
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("I have read the  Privacy Policy"),
                  const Spacer(),
                  Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                      onPressed: () async {
                        setState(() {
                          showLoading = true;
                        });
                        print("PhoneNumberPressed: " + phNumber);
                        await _auth.verifyPhoneNumber(
                          phoneNumber: phNumber,
                          verificationCompleted: (phoneAuthCredential) async {
                            setState(() {
                              showLoading = false;
                            });
                            //signInWithPhoneAuthCredential(phoneAuthCredential);
                          },
                          verificationFailed: (verificationFailed) async {
                            setState(() {
                              showLoading = false;
                            });
                            print(verificationFailed.message);
                          },
                          codeSent: (verificationId, resendingToken) async {
                            setState(() {
                              showLoading = false;
                              currentState =
                                  MobileVerificationState.SHOW_OTP_FORM_STATE;
                              this.verificationId = verificationId;
                            });
                          },
                          codeAutoRetrievalTimeout: (verificationId) async {},
                        );
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 16),
                      ))),
              const SizedBox(height: 10),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      Row(
                        children: const [
                          Text("Enter OTP", style: TextStyle(fontSize: 36)),
                          Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                          "Suspendisse cras et amet, ornare et donec tellus pellentesque. ",
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        height: 16,
                      ),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 50,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 10,
                        style: const TextStyle(fontSize: 17),
                        otpFieldStyle: OtpFieldStyle(
                            backgroundColor: Color.fromARGB(50, 0, 0, 0),
                            disabledBorderColor: Colors.pink,
                            enabledBorderColor: Colors.yellow),
                        onChanged: (pin) {
                          setState(() {
                            phOtp = pin;
                          });
                          print("Changed: " + phOtp);
                        },
                        onCompleted: (pin) {
                          print("Completed: " + phOtp);
                          setState(() {
                            phOtp = pin;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)))),
                              onPressed: () async {
                                PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: phOtp);

                                signInWithPhoneAuthCredential(
                                    phoneAuthCredential);
                              },
                              child: const Text(
                                "Verify",
                                style: TextStyle(fontSize: 16),
                              ))),
                      const Spacer(),
                    ]))));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
