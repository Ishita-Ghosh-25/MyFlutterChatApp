import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'chatroom.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethod authService = new AuthMethod();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserByUserEmail(emailEditingController.text);
         // docs[0].data()["name"])
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameInSharedPreference(
              (userInfoSnapshot.docs[0].data() as dynamic)["name"]);

          HelperFunctions.saveUserEmailInSharedPreference(
              (userInfoSnapshot.docs[0].data() as dynamic)["email"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: appBarMain(context),
        ),
        body: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                            ? null
                            : "Please Enter Correct Email";
                      },
                      controller: emailEditingController,
                      style: simpleTextField(),
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val!.length > 6
                            ? null
                            : "Enter Password 6+ characters";
                      },
                      style: simpleTextField(),
                      controller: passwordEditingController,
                      decoration: InputDecoration(
                        hintText: 'Your Password',
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                       /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword())); */
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Forgot Password?",
                          style: simpleTextField(),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.deepPurple,
                          Colors.deepPurpleAccent,
                        ],
                      )
                     ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style:  TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,

                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
             Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.deepPurple,
                        Colors.deepPurpleAccent,
                      ],
                    )
                   ),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Sign In with Google",
                    style:  TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ), textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: newTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          color: Colors.deepPurple[900],
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

