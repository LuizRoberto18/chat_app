import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String _message = '';
  final _messagController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;
    if (user != null) {
      await ChatService().save(_message, user);
      _messagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messagController,
            onChanged: (msg) => setState(() => _message = msg),
            onSubmitted: (_) {
              if(_message.trim().isNotEmpty){
                _sendMessage();
              }
            },
            decoration: const InputDecoration(
              labelText: "Enviar mensagem...",
            ),
          ),
        ),
        IconButton(
          onPressed: _message.trim().isEmpty ? null : _sendMessage,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
