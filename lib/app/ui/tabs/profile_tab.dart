import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        // Display the user's profile picture
        backgroundImage: NetworkImage(
            'https://c.wallhere.com/photos/de/ab/anime_anime_girls-1779929.jpg!d'),
        radius: 50.0,
      ),
    );
  }
}
