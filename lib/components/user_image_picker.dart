import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;

  const UserImagePicker({Key? key, required this.onImagePick}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  Future<void> _pickerImage() async {
    final picker = ImagePicker();
    final pickerImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickerImage != null) {
      setState(() {
        _image = File(pickerImage.path);
      });
      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton.icon(
          onPressed: _pickerImage,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          icon: const Icon(Icons.image),
          label: const Text("Adicionar imagem"),
        ),
      ],
    );
  }
}
