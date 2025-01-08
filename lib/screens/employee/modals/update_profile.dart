import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileModal extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(File? selectedImage, Map<String, dynamic> updatedUser) onSave;

  const EditProfileModal({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  File? _selectedImage;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.user['phoneNumber']);
    locationController = TextEditingController(text: widget.user['location']);
  }

  @override
  void dispose() {
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.user['profileImage'] != null ? NetworkImage(widget.user['profileImage']) : null)
                          as ImageProvider?,
                  child: _selectedImage == null && widget.user['profileImage'] == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Map<String, dynamic> updatedUser = {
              'phone': phoneController.text,
              'location': locationController.text,
              'profileImage': _selectedImage?.path ?? widget.user['profileImage'],
            };
            widget.onSave(_selectedImage, updatedUser);
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
