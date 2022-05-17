import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();


  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoading = false;
  void validate(){
    if(formkey.currentState!.validate()){
      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };
      HelperFunctions.saveUserEmailInSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameInSharedPreference(userNameTextEditingController.text);


      setState(() {
        isLoading = true;
      });
      authMethod.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        //print("${value.uId}");
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: appBarMain(context),
      ),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator())
      ): SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: userNameTextEditingController,
                      style: simpleTextField(),
                      decoration: InputDecoration(
                        hintText: 'Enter Username',
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Required";
                        }else if(value.length < 6) {
                          return "Should contain atleast 6  characters";
                        }
                      }
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      style: simpleTextField(),
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator:(value) {
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ? null : "provide a valid email address";
                      }
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: passwordTextEditingController,
                      style: simpleTextField(),
                      decoration: InputDecoration(
                        hintText: 'Your Password',
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Required";
                        }else if(value.length < 6) {
                          return "Should Be Atleast 6 Characters";
                        }
                      }
                  ),

                  SizedBox(height: 16,),
                  Container(
                    child: RaisedButton(
                      onPressed : validate,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.deepPurple,
                              Colors.deepPurpleAccent,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 55.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'SignUp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )
                          ),
                        ),
                      ),
                  ),
                  ),
                  SizedBox(height: 8,),
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
                  /*Container(
                    child: RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        highlightElevation: 10,
                        color: Colors.blueGrey,
                        child: Text('Sign up with Google', textAlign: TextAlign.center,),
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 90.0),
                        splashColor: Colors.grey,
                        onPressed :(){}),
                  ), */
                  SizedBox(height: 12,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: newTextStyle(),),
                        GestureDetector(
                          onTap: (){
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("SignUp Now", style: TextStyle(
                                color: Colors.deepPurple[900],
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 80,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
