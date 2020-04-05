import 'package:ssc_401/shared/mylib.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  String verificationId;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text('Welcome to Binpoint'),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding:EdgeInsets.all(24.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Image(
                  height:152,
                    width: 152,
                    image: AssetImage(
                      'assets/login_logo.png',
                    ),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Enter SG Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                 validator: (val) => val.length !=8 ?
                 'Enter valid phone number' : null,
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    highlightElevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text("Phone Sign In"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              _sendCodeToPhoneNumber(context);
                              return AlertDialog(
                                  title: Text("Enter SMS Code"),
                                  content: TextField(
                                      controller: _smsCodeController,
                                      keyboardType: TextInputType.number,
                                      onSubmitted: (value) {
                                        _signInWithPhoneNumber(value);
                                      }));
                            });
                      }
                    }
                ),
                SignInButton(
                  Buttons.Email,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)
                      => EmailSignIn()),
                    );
                  },
                ),
                SizedBox(height: 4.0),
                SignInButton(
                  Buttons.Google,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    _authService.signInWithGoogle();
                  },
                ),
              ],
            ),
          ),
        )
        );
  }

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber(context) async {
    String singaporePhoneNum = ('+65' + _phoneNumberController.text);

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      setState(() async {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $authCredential');
        FirebaseAuth _auth = FirebaseAuth.instance;
        final FirebaseUser user =
            await _auth.signInWithCredential(authCredential).then((user) {
          Navigator.pop(context);
          DatabaseService(uid:user.user.uid).createUserDataForNewUser(user.user.phoneNumber);
          print("signed in with phone number successful: user -> $user");
        }).catchError((e) {
          print(e);
        });
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + singaporePhoneNum);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: (singaporePhoneNum),
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    print("testing code");
    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user =
        await _auth.signInWithCredential(credential).then((user) {
      print("signed in with phone number successful: user -> $user");
      dispose();
    }).catchError((e) {
      print(e);
    });

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _smsCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
