import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {


@override
  void initState() {
    
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } );
    super.initState();
  }

  String _name = '';
  String _lastMessage = '';
  List<String> _messages = [];
  bool _isActive = false;
  bool isEnrollmentNumberEntered = false;
  int enrollmentNumber = 0;

  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
String fullMessage = "";
  void _sendMessage() {
    final message = _textController.text.trim();
  fullMessage = _textController.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('You: $message');
        _lastMessage = fullMessage;
        _textController.clear();
        if(double.tryParse(_lastMessage) != null){
          if(isEnrollmentNumberEntered){
            enrollmentNumber= int.parse(message.replaceAll(RegExp(r'[^0-9]'),''));
          }
           AwesomeNotifications().createNotification(content: NotificationContent(largeIcon: 'https://t3.ftcdn.net/jpg/03/22/38/32/360_F_322383277_xcXz1I9vOFtdk7plhsRQyjODj08iNSwB.jpg',id: 10, channelKey: 'basic_channel',title: 'Samir',body: "${enrollmentNumber.toString().substring(fullMessage.length -2)}",actionType: ActionType.KeepOnTop));
           _botReply();   
        }
        AwesomeNotifications().createNotification(content: NotificationContent(largeIcon: 'https://t3.ftcdn.net/jpg/03/22/38/32/360_F_322383277_xcXz1I9vOFtdk7plhsRQyjODj08iNSwB.jpg',id: 10, channelKey: 'basic_channel',title: 'Samir',body: "$message",actionType: ActionType.KeepOnTop));
        _botReply();
      });
    }
  }

  void _generateMessages() {
    final timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    final hour = timeOfDay.hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    setState(() {
      
      _messages.add('ChatBot: $greeting!');
      
      _messages.add('ChatBot: What\'s your name?');
      _isActive = true;
    });
  }

  void _botReply() {
    if (_isActive) {
      if (_lastMessage.toLowerCase().contains('samir')) {
        setState(() {
          
          _messages.add('ChatBot: Hello! ${_lastMessage.trim()}');
          _messages.add('ChatBot: How are you?');
        });
      } else if(_lastMessage.toLowerCase().contains('fine')){
          setState(() {
            _messages.add('ChatBot: Good to hear that');
          _messages.add('ChatBot: What\'s your student number?');
          isEnrollmentNumberEntered = true;
          });
      } else if(double.tryParse(_lastMessage) != null){
        setState(() {
          _messages.add('ChatBot: Service Stopped : ${fullMessage.substring(fullMessage.length -2)}');
        });
        Future.delayed(Duration(seconds: 1), () {
        exit(0);
      });
      }
      else {
        setState(() {
          _messages.add('ChatBot: I didn\'t get that');
        });
      }
      
    }
  }

  void _stopService() {
    if (_isActive) {
      setState(() {
        _messages.add('ChatBot: Goodbye Service stopped.');
        _isActive = false;
      });
      Future.delayed(Duration(seconds: 1), () {
        exit(0);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(onPressed: _sendMessage, icon: Icon(Icons.send),),
                
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _generateMessages,
                  child: Text('Generate'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopService,
                  child: Text('Stop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
