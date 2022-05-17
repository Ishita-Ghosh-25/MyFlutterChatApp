import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widget/customShape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  late Stream chatRoomStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            
            itemCount: (snapshot.data! as QuerySnapshot).docs.length.compareTo(0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                //searchSnapshot?.docs[index].data()["name"],
                //((snapshot.data! as QuerySnapshot).docs[index].data ()as dynamic)["message"]
                userName:((snapshot.data! as QuerySnapshot).docs[index].data () as dynamic)["chatRoomId"]
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myname, ""),
                chatRoomId: ((snapshot.data! as QuerySnapshot).docs[index].data () as dynamic)["chatRoomId"],
                 );
            })
            : Container();
      },
    );
  } 

  @override
  void initState() {
    super.initState();
  }
 getUserInfo() async{
    Constants.myname = (await HelperFunctions.getUserNameInSharedPreference())!;
    getUserInfo();
    databaseMethods.getChatRooms(Constants.myname).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
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
        actions: [
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:16),
              child: Icon(Icons.exit_to_app_sharp),
            )
          )
        ]
      ),
      //body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
      );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>ConversationScreen(chatRoomId),
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
