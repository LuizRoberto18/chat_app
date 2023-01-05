import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static final _defaultUser = ChatUser(
    id: '456',
    name: 'Alice',
    email: "alice@cod3r.com.br",
    imageUrl: 'assets/images/avatar.png',
  );
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _uppdateUser(_defaultUser);
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> login(String email, String password) async {
    _uppdateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _uppdateUser(null);
  }

  @override
  Future<void> signup(String name, String email, String password, File? image) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageUrl: image?.path ?? 'assets/images/avatar.png',
    );

    _users.putIfAbsent(email, () => newUser);
    _uppdateUser(newUser);
  }

  static void _uppdateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
