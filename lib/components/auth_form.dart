import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authData = AuthFormData();

  void _handleImagePicker(File image) {
    _authData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_authData.image == null && _authData.isSignup) {
      return _showError("Imagem não selecionada!");
    }
    widget.onSubmit(_authData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authData.isSignup) UserImagePicker(onImagePick: _handleImagePicker),
              if (_authData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authData.name,
                  onChanged: (name) => _authData.name = name,
                  validator: (_name) {
                    final name = _name ?? "";
                    if (name.trim().length < 5) {
                      return 'O nome deve ter no minimo 5 caracteres.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Nome",
                  ),
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _authData.email,
                onChanged: (email) => _authData.email = email,
                validator: (_email) {
                  final email = _email ?? "";
                  if (!email.contains('@')) {
                    return 'E-mail informado não é valido.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
              ),
              TextFormField(
                key: const ValueKey('password'),
                obscureText: true,
                initialValue: _authData.password,
                onChanged: (password) => _authData.password = password,
                validator: (_password) {
                  final password = _password ?? "";
                  if (password.length < 6) {
                    return 'A senha deve ter no minimo 6 caracteres.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Senha",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_authData.isLogin ? "Entrar" : "Cadastrar"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _authData.toggleAuthMode();
                  });
                },
                child: Text(
                  _authData.isLogin ? "Criar uma nova conta?" : "Já possui conta?",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
