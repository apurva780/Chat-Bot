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
        AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel',title: 'Chat Bot',body: "$message"));
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
      _messages.add('ChatBot: $greeting! Utkarsh');
      _messages.add('ChatBot: How are you?');
      _isActive = true;
    });
  }

  void _botReply() {
    if (_isActive) {
      if (_lastMessage.contains('i am fine')) {
        setState(() {
          // _name = _lastMessage.split(' ').last;
          _messages.add('ChatBot: Good to hear that');
          _messages.add('ChatBot: What\'s your student number?');
        });
      } else {
        setState(() {
          // _name = _lastMessage.split(' ').last;
          _messages.add('ChatBot: Service stopped ${fullMessage.substring(fullMessage.length -2)}');
          Navigator.of(context).pop();
          // _messages.add('ChatBot: What\'s your student number?');
        });
      }
      // } else if (_lastMessage.contains('How are you?')) {
      //   if (_lastMessage.toLowerCase().contains('fine')) {
      //     setState(() {
      //       _messages.add('ChatBot: Good to hear that. What\'s your student number?');
      //     });
      //   } else {
      //     setState(() {
      //       _messages.add('ChatBot: I\'m sorry to hear that. What\'s your student number?');
      //     });
      //   }
      // } else if (_lastMessage.contains('student number')) {
      //   final number = _lastMessage.replaceAll(RegExp(r'[^0-9]'), '');
      //   if (number.length == 2) {
      //     setState(() {
      //       _messages.add('ChatBot: Your student number is $number. Goodbye $_name! Service stopped.');
      //       _isActive = false;
      //     });
      //     Future.delayed(Duration(seconds: 2), () {
      //       Navigator.of(context).pop();
      //     });
      //   } else {
      //     setState(() {
      //       _messages.add('ChatBot: Sorry, I didn\'t get that. Please enter a valid student number.');
      //     });
      //   }
      // }
    }
  }

  void _stopService() {
    if (_isActive) {
      setState(() {
        _messages.add('ChatBot: Goodbye $_name! Service stopped.');
        _isActive = false;
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }
  // void _sendMessage() {
  //  message = _textController.text.trim();
  //   if (message.isNotEmpty) {
  //     setState(() {
  //       _messages.add('You: $message');
  //       _textController.clear();
  //       _botReply();
  //     });
  //   }
  // }

  // void _generateMessages() {
  //   final timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
  //   final hour = timeOfDay.hour;
  //   String greeting;

  //   if (hour < 12) {
  //     greeting = 'Good morning';
  //   } else if (hour < 18) {
  //     greeting = 'Good afternoon';
  //   } else {
  //     greeting = 'Good evening';
  //   }

  //   setState(() {
  //     _messages.add('ChatBot: $greeting! What\'s your name?');
  //     _isActive = true;
  //   });
  // }

  // void _botReply() {
  //   if (_isActive) {
  //     if (message.isNotEmpty) {
  //       setState(() {
  //         _name = _messages.last.split(' ').last;
  //         _messages.add('ChatBot: Hello $_name! How are you?');
  //       });
  //     } else if (_messages.last.contains('How are you?')) {
  //       setState(() {
  //         _messages.add('ChatBot: I\'m doing well, thank you for asking.');
  //       });
  //     }
  //   }
  // }

  // void _stopService() {
  //   if (_isActive) {
  //     setState(() {
  //       _messages.add('ChatBot: Goodbye $_name! Service stopped.');
  //       _isActive = false;
  //     });
  //     Future.delayed(Duration(seconds: 2), () {
  //       Navigator.of(context).pop();
  //     });
  //   }
  // }

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
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
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
