import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/components/assets_strings.dart';
import 'package:customer/components/background.dart';
import 'package:customer/components/constants.dart';
import 'package:customer/components/widgets.dart';
import 'package:customer/screens/Booking/editEvent.dart';
import 'package:customer/screens/Homescreen/MainScreen.dart';
import 'package:customer/screens/SignupLogin/Signup.dart';
import 'package:customer/screens/SignupLogin/components/login_topimg.dart';
import 'package:customer/screens/customerProfile/custprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customer/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:toastification/toastification.dart';

//loys' code
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        if (documentSnapshot.exists) {
          toastification.show(
              type: ToastificationType.success,
              context: context,
              icon: Icon(Icons.check_circle),
              title: Text('User successfully logged in!'),
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
              alignment: Alignment.topCenter,
              style: ToastificationStyle.fillColored);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const CustMainScreen())));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => AfterSignup(
                        email: email,
                        username: 'username',
                        password: password,
                      ))));
        }
      } catch (e) {
        toastification.show(
            type: ToastificationType.error,
            context: context,
            icon: Icon(Icons.error),
            title: Text('User not found!'),
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
            alignment: Alignment.topCenter,
            style: ToastificationStyle.fillColored);
        print(e);
      }
    } else {
      print('LOG IN error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoginScreenTopImage(),
                    const SizedBox(height: defaultPadding),
                    textField('Email', Icons.mail, false, _emailController),
                    const SizedBox(height: defaultPadding),
                    textField(
                        'Password', Icons.lock, true, _passwordController),
                    const SizedBox(height: defaultPadding),
                    GestureDetector(
                      onTap: _signIn,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: const Center(
                            child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(height: 5),
                    Text('OR'),
                    SizedBox(height: 5),
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: kPrimaryColor),
                            ),
                            onPressed: () {},
                            icon: Image(
                              image: AssetImage(GoogleLogoImg),
                              width: 20.0,
                            ),
                            label: Text('Login-in with Google'))),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => CustSignUp())));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
