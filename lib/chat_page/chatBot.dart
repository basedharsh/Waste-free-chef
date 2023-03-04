import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: ()async{

            dynamic conversationObject = {
              'appId': '33f46f0a6e967a48578e561a8b05f001c',// The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
              'withPreChat': true
            };

            KommunicateFlutterPlugin.buildConversation(conversationObject)
                .then((clientConversationId) {
              print("Conversation builder success : " + clientConversationId.toString());
            }).catchError((error) {
              print("Conversation builder error : " + error.toString());
            });

          },
            child: Text("Chattt")
        ),
      ),
    );
  }
}

