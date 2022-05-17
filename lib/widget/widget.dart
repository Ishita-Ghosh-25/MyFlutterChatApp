import 'package:chat_app/widget/customShape.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 90,
      backgroundColor: Colors.transparent,
      elevation: 0.0,

      flexibleSpace: ClipPath(
        clipper: customShape(),
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.deepPurple,
                    Colors.deepPurpleAccent,
                  ],
                )
            ),
          child: Center(child: Text("ChatBit", style: TextStyle(fontSize: 20, color: Colors.white),))
        ),
      ),
    ),
  );
}



TextStyle simpleTextField(){
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold
  );
}

TextStyle newTextStyle(){
  return TextStyle(
    color: Colors.deepPurple[900],
    fontSize: 17,
  );
}