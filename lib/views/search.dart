import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:icon_decoration/icon_decoration.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
 QuerySnapshot<Map<String, dynamic>> ?searchSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  initiateSearch() async {
    await databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() { //Recreates the whole screen with updated data
        searchSnapshot = value;
      });
    });
  }
//create Chatroom, Send User To Conversation Screen, push replacement

  createChatRoomAndStartConversation({required String userName}){
    if(userName != Constants.myname){
      String chatRoomId = getChatRoomId(userName, Constants.myname);
      List<String> users = [Constants.myname,userName];
      Map<String, dynamic> chatRoomMap ={
        "users" :users,
        "chatRoomId" : chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
      ));
    }else {
      print("You cant send message to yourself");
    }

  }


  Widget SearchTile({required String userName, required String userEmail}){
    return Container(

      padding: EdgeInsets.symmetric(horizontal : 24, vertical : 16),
      child: Row(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,style: TextStyle(color: Colors.purpleAccent, fontSize: 16),),
                Text(userEmail,style: TextStyle(color: Colors.white, fontSize: 16),)
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName : userName);
            },
            child: Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
               colors: [
                Colors.deepPurple,
                Colors.deepPurpleAccent,
              ],
              ),
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: appBarMain(context),
      ),
      body: Container(
        
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia'),
                        decoration: InputDecoration(
                            hintText: "Search User Name...",
                            hintStyle: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),),),


                    GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                            height: 30, width: 40,

                          child:  DecoratedIcon(
                              icon: Icon(Icons.search_rounded, color: Colors.deepPurple),
                              decoration: IconDecoration(border: IconBorder(),shadows: [Shadow(blurRadius: 5, offset: Offset(2, 0))]),
                          )

                        )
                    ),
                  ],
                ),
              ),
              searchList()
            ],
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot?.docs.length.compareTo(0),
          itemBuilder: (context, index) {
          return SearchTile(
            userName: searchSnapshot?.docs[index].data()["name"],
            userEmail: searchSnapshot?.docs[index].data()["email"],
          );
        }) : Container();
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}


