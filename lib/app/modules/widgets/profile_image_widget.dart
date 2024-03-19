import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final File? localFile;
  final VoidCallback onAddImage;
  final bool editable;
  final double size;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.localFile,
    required this.onAddImage,
    this.size = 150,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            InkWell(
              onTap: () => onAddImage.call(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: localFile != null
                      ? Image.file(localFile!, width: 150, height: 150, fit: BoxFit.cover)
                      : (imageUrl ?? '').isNotEmpty
                          ? Image.network(imageUrl!, width: 150, height: 150, fit: BoxFit.cover)
                          : Image.asset("assets/profile_dummy.webp", width: 150, height: 150, fit: BoxFit.cover),
                ),
              ),
            ),
            if (editable)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => onAddImage.call(),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
