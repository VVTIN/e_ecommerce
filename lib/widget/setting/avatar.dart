import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/DB_helper.dart';
import '../../model/currentUser.dart';


class AvatarUser extends StatefulWidget {
  const AvatarUser({super.key});

  @override
  State<AvatarUser> createState() => _AvatarUserState();
}

class _AvatarUserState extends State<AvatarUser> {
  String _selectedImagePath = '';

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    // Replace with the actual user ID or obtain it from the current session
    final userId = CurrentUser().id!;
    
    // Get the user's profile information to retrieve the avatar URL
    final userProfile = await DatabaseHelper.dataService.getUserById(userId);
    if (userProfile.isNotEmpty) {
      setState(() {
        _selectedImagePath = userProfile.first['avatarUrl'] ?? '';
      });
    }
  }

  void showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.photo),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.camera),
              title: const Text('Chụp ảnh'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickImage = await ImagePicker().pickImage(source: source);
    if (pickImage != null) {
      setState(() {
        _selectedImagePath = pickImage.path;
      });

      // Save the avatar path in the database
      final userId = CurrentUser().id!;
      await DatabaseHelper.dataService.updateUserAvatar(userId, pickImage.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không chọn ảnh!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showImageOptions(context),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
             
              radius: 34,
              backgroundImage: _selectedImagePath.isEmpty
                  ? const NetworkImage(
                      'https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg')
                  : kIsWeb
                      ? NetworkImage(_selectedImagePath) as ImageProvider<Object>
                      : FileImage(File(_selectedImagePath)),
            ),
            Positioned(
              bottom: 0,
              left: 29,
              child: CircleAvatar(
                child: const Icon(Icons.add, size: 10),
                radius: MediaQuery.sizeOf(context).width * 0.015,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
