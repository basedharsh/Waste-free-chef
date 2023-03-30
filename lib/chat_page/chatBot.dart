import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase/chat_page/Messages.dart';
import 'package:flutter/material.dart';

class Chatbotsupport extends StatefulWidget {
  const Chatbotsupport({Key? key}) : super(key: key);

  @override
  _ChatbotsupportState createState() => _ChatbotsupportState();
}

class _ChatbotsupportState extends State<Chatbotsupport> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Column(
            children: [
              Expanded(child: MessagesScreen(messages: messages)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 255, 161, 161),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    )),
                    IconButton(
                        onPressed: () {
                          sendMessage(_controller.text);
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
